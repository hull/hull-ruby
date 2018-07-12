require 'hull/config'
require 'hull/connection'
require 'hull/request'
require 'hull/firehose'
require 'base64'
require 'openssl'
require 'jwt'

module Hull
  class Client

    attr_accessor *Config::VALID_OPTIONS_KEYS

    include Hull::Connection
    include Hull::Request
    include Hull::Firehose

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
        :app_id       => @app_id,
        :app_secret   => @app_secret,
        :user_id      => @user_id,
        :access_token => @access_token,
        :organization => organization
      }
    end

    def user_token user, claims={}
      claims = claims.inject({}) { |c,(k,v)| c.merge(k.to_sym => v) }
      if user.is_a?(String)
        claims[:sub] = user
      else
        claims[:'io.hull.asUser'] = user
      end
      claims = claims.merge({ iat: Time.now.to_i, iss: app_id })
      claims[:nbf] = claims[:nbf].to_i if claims[:nbf]
      claims[:exp] = claims[:exp].to_i if claims[:exp]
      JWT.encode(claims, app_secret)
    end

  end
end
