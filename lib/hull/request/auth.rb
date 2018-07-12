require 'digest/md5'

module Hull
  module Request
    class Auth  < Faraday::Middleware

      def call(env)
        env[:request_headers]["Hull-Organization"] = @credentials[:organization]
        env[:request_headers]["Hull-App-Id"] = @credentials[:app_id]
        if !@credentials[:access_token].nil?
          env[:request_headers]["Hull-Access-Token"] = @credentials[:access_token]
        else
          env[:request_headers]["Hull-Access-Token"] = @credentials[:app_secret]
          env[:request_headers]["Hull-User-Id"] = @credentials[:user_id] if @credentials[:user_id]
        end
        @app.call(env)
      end

      def initialize(app, credentials)
        @app, @credentials = app, credentials
      end

    end
  end
end
