require 'hull/config'
require 'hull/connection'
require 'hull/request'
require 'base64'
require 'openssl'
require 'jwt'

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
        :app_id       => @app_id,
        :app_secret   => @app_secret,
        :user_id      => @user_id,
        :access_token => @access_token
      }
    end

    def app
      return unless app_id
      @app ||= get("/app", :app_id => app_id)
    end


    def read_cookie str
      return if str.nil? || str.length == 0
      JSON.parse(Base64.decode64(str)) rescue nil
    end

    def current_user_id user_id, user_sig
      return unless user_id && user_sig
      time, signature = user_sig.split(".")
      data    = [time, user_id].join("-")
      digest  = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'), self.app_secret, data)
      return user_id if digest == signature
    end

    def authenticate_user env
      require 'rack/request'
      request = Rack::Request.new(env)
      cookie  = request.cookies["hull_#{self.app_id}"]
      user_auth = read_cookie(cookie)
      return unless user_auth
      current_user_id(user_auth['Hull-User-Id'], user_auth['Hull-User-Sig'])
    end

    def user_hash user_infos
      timestamp = Time.now.to_i.to_s
      message = Base64.encode64(user_infos.to_json).gsub("\n", "")
      sig = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'), app_secret, [message, timestamp].join(" "))
      [message, sig, timestamp].join(" ")
    end

    def user_token user, claims={}
      claims = claims.inject({}) { |c,(k,v)| c[k.to_sym] = v }
      if user.is_a?(String)
        claims[:sub] = user
      else
        claims[:'io.hull.user'] = user
      end
      claims = claims.merge({ iat: Time.now.to_i, iss: app_id })
      claims[:nbf] = claims[:nbf].to_i if claims[:nbf]
      claims[:exp] = claims[:exp].to_i if claims[:exp]
      JWT.encode(claims, app_secret)
    end

  end
end
