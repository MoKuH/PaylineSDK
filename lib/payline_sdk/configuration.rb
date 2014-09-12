module PaylineSDK
  class Configuration

    API = YAML.load(File.read([(File.expand_path '../../..', __FILE__), 'files', 'settings.yml'].join('/'))).freeze

    attr_accessor :file, :merchant_id, :access_key, :environment

    def initialize
      @file = [PaylineSDK.root, 'files', 'payline.wsdl'].join('/')
    end

    def self.api_methods
      API[:apis].keys.each do |api|
        return API[:apis][api][:methods].map {|method| method[:name]}
      end
      return []
    end

  end
end
