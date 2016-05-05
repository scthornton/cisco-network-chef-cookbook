#!/usr/local/rvm/rubies/ruby-2.2.1/bin/ruby
#
# This file was generated by RubyGems.
#
# The application 'grpc' is installed as part of a gem, and
# this file is here to facilitate running it.
#

require 'rubygems'

version = ">= 0"

if ARGV.first
  str = ARGV.first
  str = str.dup.force_encoding("BINARY") if str.respond_to? :force_encoding
  if str =~ /\A_(.*)_\z/ and Gem::Version.correct?($1) then
    version = $1
    ARGV.shift
  end
end

gem 'grpc', version
load Gem.bin_path('grpc', 'noproto_server.rb', version)
