require 'json'
require 'rack/request'

module Hull::Middlewares
  class Hook

    attr_reader :options

    def initialize app, options={}, &handler
      @app      = app
      @options  = options
      if block_given?
        @handler  = handler
      elsif options[:handler]
        @handler = options[:handler]
      end
    end

    def call env
      path = options[:path] || "/__hull-hooks__"
      if env['PATH_INFO'] == path && valid?(env)
        begin
          request   = Rack::Request.new(env)
          event     = JSON.parse(request.body.read)
          response  = (@handler.call(event, request) || "ok").to_s
          [200, { 'Content-Type' => 'text/html' }, [response]]
        rescue => err
          [500, { 'Content-Type' => 'text/html' }, ["Invalid Request: #{err.inspect}"]]
        end
      else
        @app.call(env)
      end
    end

    def valid? env
      body = env['rack.input'].read
      env['rack.input'].rewind
      timestamp, nonce, signature = (env['HTTP_HULL_SIGNATURE'] || "").split('.')
      data    = [timestamp, nonce, body].join("-")
      signature == OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'), options[:secret], data)
    end

  end
end