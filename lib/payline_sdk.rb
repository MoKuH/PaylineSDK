require 'active_support/all'
require "payline_sdk/version"
require "nokogiri"
require "yaml"

require "payline_sdk/configuration"
require "payline_sdk/object/base"
require "payline_sdk/client"
require "payline_sdk/request"

module PaylineSDK

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    self.define_objects
    yield(configuration)
  end

  def self.root
    File.expand_path '../..', __FILE__
  end

  private

    def self.define_objects
      PaylineSDK::Configuration::API[:objects].keys.each do |key|
        attributes = PaylineSDK::Configuration::API[:objects][key][:attributes].map {|attr| attr[:name]}
        klass = Class.new(PaylineSDK::Object::Base) do
          attributes.each do |attribute|
            define_method attribute.to_sym do
              instance_variable_get("@#{attribute}")
            end
            define_method "#{attribute}=".to_sym do |arg|
              instance_variable_set("@#{attribute}", arg)
            end
          end

          define_method :to_h do
            Hash[attributes.zip(attributes.map {|attr| eval("@#{attr}")})]
          end
        end
        PaylineSDK::Object.const_set(key.to_s.camelize, klass)
      end
    end

end
