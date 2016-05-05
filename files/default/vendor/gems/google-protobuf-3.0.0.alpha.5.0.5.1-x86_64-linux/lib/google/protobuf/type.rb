# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: google/protobuf/type.proto

require 'google/protobuf'

require 'google/protobuf/any'
require 'google/protobuf/source_context'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "google.protobuf.Type" do
    optional :name, :string, 1
    repeated :fields, :message, 2, "google.protobuf.Field"
    repeated :oneofs, :string, 3
    repeated :options, :message, 4, "google.protobuf.Option"
    optional :source_context, :message, 5, "google.protobuf.SourceContext"
    optional :syntax, :enum, 6, "google.protobuf.Syntax"
  end
  add_message "google.protobuf.Field" do
    optional :kind, :enum, 1, "google.protobuf.Field.Kind"
    optional :cardinality, :enum, 2, "google.protobuf.Field.Cardinality"
    optional :number, :int32, 3
    optional :name, :string, 4
    optional :type_url, :string, 6
    optional :oneof_index, :int32, 7
    optional :packed, :bool, 8
    repeated :options, :message, 9, "google.protobuf.Option"
    optional :json_name, :string, 10
    optional :default_value, :string, 11
  end
  add_enum "google.protobuf.Field.Kind" do
    value :TYPE_UNKNOWN, 0
    value :TYPE_DOUBLE, 1
    value :TYPE_FLOAT, 2
    value :TYPE_INT64, 3
    value :TYPE_UINT64, 4
    value :TYPE_INT32, 5
    value :TYPE_FIXED64, 6
    value :TYPE_FIXED32, 7
    value :TYPE_BOOL, 8
    value :TYPE_STRING, 9
    value :TYPE_GROUP, 10
    value :TYPE_MESSAGE, 11
    value :TYPE_BYTES, 12
    value :TYPE_UINT32, 13
    value :TYPE_ENUM, 14
    value :TYPE_SFIXED32, 15
    value :TYPE_SFIXED64, 16
    value :TYPE_SINT32, 17
    value :TYPE_SINT64, 18
  end
  add_enum "google.protobuf.Field.Cardinality" do
    value :CARDINALITY_UNKNOWN, 0
    value :CARDINALITY_OPTIONAL, 1
    value :CARDINALITY_REQUIRED, 2
    value :CARDINALITY_REPEATED, 3
  end
  add_message "google.protobuf.Enum" do
    optional :name, :string, 1
    repeated :enumvalue, :message, 2, "google.protobuf.EnumValue"
    repeated :options, :message, 3, "google.protobuf.Option"
    optional :source_context, :message, 4, "google.protobuf.SourceContext"
    optional :syntax, :enum, 5, "google.protobuf.Syntax"
  end
  add_message "google.protobuf.EnumValue" do
    optional :name, :string, 1
    optional :number, :int32, 2
    repeated :options, :message, 3, "google.protobuf.Option"
  end
  add_message "google.protobuf.Option" do
    optional :name, :string, 1
    optional :value, :message, 2, "google.protobuf.Any"
  end
  add_enum "google.protobuf.Syntax" do
    value :SYNTAX_PROTO2, 0
    value :SYNTAX_PROTO3, 1
  end
end

module Google
  module Protobuf
    Type = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.protobuf.Type").msgclass
    Field = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.protobuf.Field").msgclass
    Field::Kind = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.protobuf.Field.Kind").enummodule
    Field::Cardinality = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.protobuf.Field.Cardinality").enummodule
    Enum = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.protobuf.Enum").msgclass
    EnumValue = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.protobuf.EnumValue").msgclass
    Option = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.protobuf.Option").msgclass
    Syntax = Google::Protobuf::DescriptorPool.generated_pool.lookup("google.protobuf.Syntax").enummodule
  end
end
