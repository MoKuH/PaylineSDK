module PaylineSDK
  class Client

    PAYLINE_NAMESPACE = 'http://obj.ws.payline.experian.com'.freeze
    PROD_ENDPOINT = 'https://services.payline.com/V4/services/'.freeze
    HOMO_ENDPOINT = 'https://homologation.payline.com/V4/services/'.freeze

    DIRECT_API = 'DirectPaymentAPI'.freeze
    EXTENDED_API = 'ExtendedAPI'.freeze
    WEB_API = 'WebPaymentAPI'.freeze

    attr_accessor :web_client, :direct_client, :extended_client, :attributes

    def initialize
      @env = PaylineSDK.configuration.environment
      init_clients(PaylineSDK.configuration.file, PaylineSDK.configuration.merchant_id, PaylineSDK.configuration.access_key)
    end

    PaylineSDK::Configuration::API[:apis].keys.each do |api|
      PaylineSDK::Configuration::API[:apis][api][:methods].each do |method|
        define_method(method[:name]) do |request|
          attrs = method[:attributes].map {|attr| attr[:name]}
          # ap __method__
          # ap attrs
          response = get_client_for_method(method[:name]).call(__method__) do
            message(request.to_requestable_hash(attrs))
          end
          clean_response(response.body[("#{__method__.to_s}_response").to_sym])
        end
      end
    end

    protected

      def clean_response(hash)
        hash.each do |k,v|
          if v.is_a?(Hash)
            v = clean_response(v)
            next
          end
          if k == :@xmlns
            hash.delete(k)
          end
        end
      end

      def init_clients(file, merchant_id, access_key, opts = {})
        env = @env
        endpoint = if @env == :test
          HOMO_ENDPOINT
        elsif @env == :production
          PROD_ENDPOINT
        end

        ['web', 'direct', 'extended'].each do |type|
          client = Savon.client do
            basic_auth merchant_id, access_key
            wsdl(file)
            pretty_print_xml(true) if env == :test
            namespace(PAYLINE_NAMESPACE)
            endpoint(endpoint + eval("#{type.upcase}_API"))
          end
          instance_variable_set("@#{type}_client", client)
        end
      end

      def get_client_for_method(method_name)
        PaylineSDK::Configuration::API[:apis].keys.each do |api|
          PaylineSDK::Configuration::API[:apis][api][:methods].each do |method|
            if method[:name] == method_name
              case api
              when :web_payment_api
                return @web_client
              when :direct_payment_api
                return @direct_client
              when :extended_api
                return @extended_client
              end
            end
          end
        end
        return nil
      end

  end
end
