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

  end
end