module PaylineSDK
  module Object
    class Base

      def initialize(opts = {})
        set_attributes(opts)
      end

      def set_attributes(attributes)
        attributes.each do |k,v|
          instance_variable_set("@#{k}", v)
        end
      end

      def to_h
        {}
      end

    end
  end
end
