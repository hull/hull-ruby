module Hull
  # Defines HTTP request methods
  module Request
    API_PATH_REGEXP = /^\/?api\/v1\//
    API_PATH = '/api/v1/'

    # Perform an HTTP DELETE request
    def delete(path, params={}, options={})
      request(:delete, api_path(path), params, options)
    end

    # Perform an HTTP GET request
    def get(path, params={}, options={})
      request(:get, api_path(path), params, options)
    end

    # Perform an HTTP POST request
    def post(path, params={}, options={})
      request(:post, api_path(path), params, options)
    end

    # Perform an HTTP PUT request
    def put(path, params={}, options={})
      request(:put, api_path(path), params, options)
    end

    private

    def api_path(path)
      if path =~ API_PATH_REGEXP
        path.gsub(API_PATH_REGEXP, API_PATH)
      else
        API_PATH + (path[0] == '/' ? path[1..-1] : path)
      end
    end

    # Perform an HTTP request
    def request(method, path, params={}, opts={})
      options = { url: "https://#{organization}" }.merge(opts)
      response = connection(options).run_request(method, nil, nil, nil) do |request|
        if request.options.is_a?(Hash)
          request.options[:timeout]       ||= options.fetch(:timeout, 10)
          request.options[:open_timeout]  ||= options.fetch(:open_timeout, 10)
        elsif request.options.respond_to?(:timeout)
          request.options.timeout         ||= options.fetch(:timeout, 10)
          request.options.open_timeout    ||= options.fetch(:open_timeout, 10)
        end

        case method.to_sym
        when :delete, :get
          request.url(path, params)
        when :post, :put
          request.path = path
          request.body = MultiJson.dump(params) unless params.empty?
        end
      end
      options[:raw] ? response : response.body
    end
  end
end
