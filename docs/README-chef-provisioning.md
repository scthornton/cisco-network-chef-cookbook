# Automated Chef Client Installation Using Chef-Provisioning

1. [Overview](#overview)
2. [Pre-Install Tasks](#pre-install)
3. [Workstation Setup](#workstation)
4. [Target Node Setup](#node)
5. [Chef Provisioning Recipe](#recipe)
6. [Running the Chef Provisioning Recipe](#running)
7. [Troubleshooting](#troubleshooting)

## <a name="overview">Overview</a>

This document describes automated Chef client installation and setup on Cisco Nexus switches using the [Chef Provisioning](https://github.com/chef/chef-provisioning/) and [Chef Provisioning SSH](https://github.com/chef/chef-provisioning-ssh) Ruby gems.

## <a name="pre-install">Pre-Install Tasks</a>

### Platform and Software Support

See [Requirements](../README.md#requirements) for details on platform and software requirements.

Additionally, all of the following software versions are required:

* Chef Provisioning 1.3.0 or later
* Chef Provisioning SSH 0.0.10 or later

### Disk space

400MB of free disk space on bootflash is recommended before installing the
Chef client software on the target agent node.

### Environment
NX-OS supports three possible environments for running third party software:
`bash-shell`, `guestshell` and the `open agent container (OAC)`.

Environment                  | Supported Platforms       |
-----------------------------|---------------------------|
`bash-shell`                 | Cisco Nexus N3k, N9k, N9k-F |
`guestshell`                 | Cisco Nexus N3k, N9k, N9k-F |
`open agent container (OAC)` | Cisco Nexus N5k, N6k, N7k |

You may run chef-client in any of the three supported environments but not simultaneously.

 Environment                 | Description |
-----------------------------|------------------------------------------|
`bash-shell` | This is the native WRL Linux environment underlying NX-OS. It is disabled by default.
`guestshell` | This is a secure Linux container environment running CentOS. It is enabled by default in most platforms that support it.
`open agent container (OAC)` <sup>1</sup> | <li> This is a 32-bit CentOS-based container created specifically for running Puppet Agent software. </li><li> OAC containers are created for specific platforms and must be downloaded from Cisco.</li><li> The OAC must be installed before the Puppet Agent can be installed.</li>

Access the following [link](README-agent-install.md) for more information on enabling these environments.

<sup>1</sup>*Automated chef-client installation is currently not supported in the `open agent container (OAC)` environment. This may change in future releases.*

## <a name="workstation">Workstation Setup</a>

This document assumes you already have a Chef workstation set up. The below are additional steps needed to use your Chef workstation for Chef Provisioning.

### Gem installation

Install both gems on your Chef workstation. You may need to use `sudo` depending on your permissions setup.

```bash
chefws$ sudo /opt/chef/embedded/bin/gem install chef-provisioning chef-provisioning-ssh
```

### Chef server certificate

Fetch a copy of the certificate for your Chef server and mark it as trusted:

```bash
chefws$ sudo knife ssl fetch -c /etc/chef/client.rb
WARNING: Certificates from chefserver.example.com will be fetched and placed in your trusted_cert
directory (/etc/chef/trusted_certs).

Knife has no means to verify these are the correct certificates. You should
verify the authenticity of these certificates after downloading.

Adding certificate for chefserver.example.com in /etc/chef/trusted_certs/chefserver_example_com.crt
chefws$
```

## <a name="node">Target Node Setup</a>

The SSH feature needs to be enabled and a devops user with sudo access will be needed for the Chef workstation to access and install the Chef client software into the `bash-shell` or `guestshell` environment.

**Example:**

```bash
configure terminal
  feature ssh
  username devops password devopspassword role network-admin
  username devops shelltype bash
end
```

Additional setup needed for `bash-shell` or `guestshell` (whether using Chef Provisioner or a manual installation) is documented [here](README-agent-install.md).

## <a name="recipe">Chef Provisioning Recipe</a>

For example, `chef_provisioning.rb`:

```ruby
require 'chef/provisioning/ssh_driver'

with_driver 'ssh'

with_chef_server 'https://chefserver.example.com/organizations/chef',
  :client_name => 'chefuser',
  :signing_key_filename => '/etc/chef/chefuser.pem'

with_machine_options :transport_options => {
  :ip_address => '10.100.100.1',
  :username => 'devops',
  :options => {
    # BASH-SHELL options - uncomment if installing to bash-shell
    # :prefix => 'sudo ip netns exec management ',

    # GUESTSHELL options - uncomment if installing to guestshell
    # :prefix => '/isan/bin/guestshell sudo ip netns exec management ',
    # :scp_temp_dir => '/bootflash',
  },
  :ssh_options => {
    :password => 'devopspassword',
  },
}

machine "n3k_100_1.example.com" do
  action [:ready, :setup, :converge]
  # Copy the trusted certificate to the newly provisioned node
  file '/etc/chef/trusted_certs/chefserver_example_com.crt', '/etc/chef/trusted_certs/chefserver_example_com.crt'
  converge true
end
```

### Bash-shell versus guestshell

As can be seen above, the difference between a `bash-shell` recipe and a `guestshell` recipe is quite small and only exists in the `transport_options` `options` hash.

* `bash-shell`
  * `:prefix => 'sudo ip netns exec management '`
     * The `prefix` string is prepended to all commands executed on the node by Chef Provisioning SSH. This prefix causes all commands to be run as root in the `management` VRF namespace.
* `guestshell`
  * `:prefix => '/isan/bin/guestshell sudo ip netns exec management '`
     * As above, but the addition of `/isan/bin/guestshell` causes commands to be executed in `guestshell` instead of `bash-shell`.
  * `:scp_temp_dir => '/bootflash'`
     * Because `guestshell` does not have access to the `bash-shell` `/tmp` directory, but does have access to `/bootflash`, we upload files via SCP to `/bootflash` in order to make them visible to `guestshell`.

## <a name="running">Running The Chef Provisioning Recipe</a>

```bash
chefws$ chef-client -z chef_provisioning.rb
```

## <a name="troubleshooting">Troubleshooting</a>

### "Unable to connect"

If you get an error like the following:

```
RuntimeError
------------
UNABLE to Connect to 10.100.100.1 using devops and {:user=>"devops", :password=>"devopspassword", :timeout=>30, :keys=>[]}
```

then you may have a stale SSH key in your `~/.ssh/known_hosts` - remove it and rerun.

### Net::HTTPServerException: 401 "Unauthorized"

You can get this error if your Chef workstation's clock is not in sync with the Chef server. Ensure that their clocks are synchronized, preferably with NTP.
