require 'hull/version'

module Hull
  # Defines constants and methods related to configuration
  module Config

    # The HTTP connection adapter that will be used to connect if none is set
    DEFAULT_ADAPTER = :net_http

    # The Faraday connection options if none is set
    DEFAULT_CONNECTION_OPTIONS = {}


    # The client ID if none is set
    DEFAULT_APP_SECRET = ENV['HULL_APP_SECRET']
    DEFAULT_APP_ID =     ENV['HULL_APP_ID']

  
    # The endpoint that will be used to connect if none is set
    #
    DEFAULT_ENDPOINT = ENV['HULL_ORG_URL']

    DEFAULT_CACHE_STORE = nil

    DEFAULT_PROXY = nil
    
    # The value sent in the 'User-Agent' header if none is set
    DEFAULT_USER_AGENT = "Hull Ruby Gem #{Hull::VERSION}"

    DEFAULT_LOGGER = nil

    # An array of valid keys in the options hash when configuring a {Hull::Client}
    VALID_OPTIONS_KEYS = [
      :proxy,
      :adapter,
      :connection_options,
      :app_id,
      :app_secret,
      :endpoint,
      :user_agent,
      :cache_store,
      :logger
    ]

    attr_accessor *VALID_OPTIONS_KEYS

    def domain
      @domain ||= URI.parse(endpoint).host unless endpoint.nil?
    end

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
      self
    end

    # Create a hash of options and their values
    def options
      options = {}
      VALID_OPTIONS_KEYS.each{|k| options[k] = send(k)}
      options
    end

    # Reset all configuration options to defaults
    def reset
      @domain                 = nil
      self.proxy              = DEFAULT_PROXY
      self.logger             = DEFAULT_LOGGER
      self.adapter            = DEFAULT_ADAPTER
      self.connection_options = DEFAULT_CONNECTION_OPTIONS
      self.app_id             = DEFAULT_APP_ID
      self.app_secret         = DEFAULT_APP_SECRET
      self.endpoint           = DEFAULT_ENDPOINT
      self.user_agent         = DEFAULT_USER_AGENT
      self.cache_store        = DEFAULT_CACHE_STORE
      self
    end

  end
end
