module PaylineSDK
  class Request

    def initialize(opts = {})
      define_accessors
      set_attributes(opts)
      self.version = 3
    end

    def set_attributes(attributes)
      attributes.each do |k,v|
        instance_variable_set("@#{k}", v)
      end
    end

    ## Recursive method to transform the following objects to Hash (Search in depth):
    ##   - PaylineSDK::Object::Base
    ##   - Un objet definissant la methode :to_payline_sdk_obj
    def to_requestable_attribute(obj)
      if obj.is_a?(Hash)
        obj.each do |k,v|
          obj[k] = to_requestable_attribute(v)
        end
      elsif obj.is_a?(PaylineSDK::Object::Base)
        obj = to_requestable_attribute(obj.to_h)
      elsif obj.class.method_defined?(:to_payline_sdk_obj)
        obj = to_requestable_attribute(obj.to_payline_sdk_obj.to_h)
      end
      return obj
    end

    ## Transform current Request object to hash
    def to_requestable_hash(allowed_keys)
      Hash[allowed_keys.zip(allowed_keys.map {|key| to_requestable_attribute(eval("@#{key.to_s}"))})]
    end

    private

      def define_accessors
        get_attributes_from_api.each do |method|
          self.class.send(:attr_accessor, method)
        end
      end

      def get_attributes_from_api
        attributes = []
        PaylineSDK::Configuration::API[:apis].keys.each do |api|
          PaylineSDK::Configuration::API[:apis][api][:methods].each do |method|
            method[:attributes].each {|attribute| attributes << attribute[:name]}
          end
        end
        return attributes.uniq!
      end

  end
end
