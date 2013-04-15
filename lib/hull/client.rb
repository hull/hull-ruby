require 'hull/config'
require 'hull/connection'
require 'hull/request'

module Hull
  class Client

    attr_accessor *Config::VALID_OPTIONS_KEYS

    include Hull::Connection
    include Hull::Request

    # Initializes a new API object
    #
    # @param attrs [Hash]
    # @return [Hull::Client]
    def initialize(attrs={})
      attrs = Hull.options.merge(attrs)
      Config::VALID_OPTIONS_KEYS.each do |key|
        instance_variable_set("@#{key}".to_sym, attrs[key])
      end
    end

    def credentials
      {
        :app_id           => app_id,
        :app_secret       => app_secret
      }
    end
    
    def app
      return unless app_id
      @app ||= get("/app", :app_id => app_id)
    end

  end
end