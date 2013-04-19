require 'json'

module Hull

  class Paywall


    class Request

      attr_reader :user_id, :authorized_contents

      def initialize env, secret
        @env      = env
        @secret   = secret
        @request  = Rack::Request.new(env)
        @user_id  = Hull.authenticate_user(env)
        @cookie_name = "_hull_p#{Hull.app_id}"
        raw_cookie = @request.cookies[@cookie_name]
        if raw_cookie
          decoded_cookie = Base64.decode64(raw_cookie) rescue nil
          sig, val = JSON.parse(decoded_cookie) rescue []
          @authorized_contents = check_signature(sig, val) ? val : []
        end
        @authorized_contents ||= []
      end

      def sign val
        OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'), @secret, val)
      end

      def check_signature sig, val
        return false unless @user_id
        return false if sig.nil? || val.nil?
        sig == sign(val.to_json)
      end

      def fetch_authorized_contents
        return [] if @user_id.nil?
        badges = Hull.get("#{user_id}/badges") || []
        @authorized_contents = badges.map do |badge|
          if badge['data'] && badge['data']['transactions']
            badge['data']['transactions'].map do |k,t|
              t['permalink']
            end
          end
        end.compact.flatten.uniq.sort
        @authorized_contents
      end

      def check_authorization_for key
        return false unless @user_id
        @authorized_contents.include?(key) or fetch_authorized_contents.include?(key)
      end

      def set_cookie headers
        if !@user_id.nil? && @authorized_contents.length > 0
          signed_cookie = Base64.encode64([sign(@authorized_contents.to_json), @authorized_contents].to_json)
          Rack::Utils.set_cookie_header!(headers, @cookie_name, {
            :value => signed_cookie,
            :path => "/"
          })
        else
          Rack::Utils.delete_cookie_header!(headers, @cookie_name, {
            :path => "/"
          })
        end
      end

    end

    def initialize app, options={}
      @app      = app
      @options  = options
      Hull.configure do |config|
        config.app_id      = @options[:app_id]      || ENV['HULL_APP_ID']
        config.app_secret  = @options[:app_secret]  || ENV['HULL_APP_SECRET']
        config.endpoint    = @options[:endpoint]    || ENV['HULL_ORG_URL']
      end
      @paths = @options[:paths].map { |k,v| [Regexp.new(k), v] }
    end

    def secure_content env, rule
      paywall = Hull::Paywall::Request.new(env, Hull.app_secret)
      if paywall.check_authorization_for(rule[:permalink])
        status, headers, body = @app.call(env)
        paywall.set_cookie(headers)
        [status, headers, body]
      else
        status  = 302
        redirect_to = rule[:redirect] || '/'
        headers = { 'Content-Type' => 'text/html' }
        body = ''
        if env['PATH_INFO'] != redirect_to
          headers['Location'] = redirect_to
        else
          status  = 401
          body    = "Access Denied..."
        end
        paywall.set_cookie(headers)
        [status, headers, [body]]
      end
      
    end

    def content_rule_for(path)
      ret = false
      @paths.map do |p|
        match, rule = p
        break if ret
        ret = rule if match && match =~ path
      end
      ret
    end

    def call env
      rule = content_rule_for(env['PATH_INFO'])

      if rule
        secure_content(env, rule)
      else
        @app.call(env)
      end
    end

  end

end