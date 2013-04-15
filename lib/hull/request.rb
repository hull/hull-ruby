module Hull
  # Defines HTTP request methods
  module Request
    
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

    def api_path path
      if path =~ /^\//
        path.to_s
      else
        "/api/v1/#{path.to_s.gsub(/^\//, '')}"
      end
    end

    # Perform an HTTP request
    def request(method, path, params={}, options={})
      Hull.log("#{method.upcase} #{path} - params: #{params.to_json}")
      response = connection(options).run_request(method, nil, nil, nil) do |request|
        request.options[:raw] = true if options[:raw]
        case method.to_sym
        when :delete, :get
          request.url(path, params)
        when :post, :put
          request.path = path
          request.body = params unless params.empty?
        end
      end
      options[:raw] ? response : response.body
    end

  end
end
