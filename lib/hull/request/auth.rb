require 'digest/md5'

module Hull
  module Request
    class Auth  < Faraday::Middleware

      def call(env)
        env[:request_headers]["Hull-Access-Token"] = @credentials[:app_secret]
        env[:request_headers]["Hull-App-id"] = @credentials[:app_id]
        @app.call(env)
      end

      def initialize(app, credentials)
        @app, @credentials = app, credentials
      end

    end
  end
end