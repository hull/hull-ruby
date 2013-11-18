require 'faraday_middleware/response_middleware'

module Hull::Response

  class ParseJson < FaradayMiddleware::ResponseMiddleware
    dependency do
      require 'multi_json'
    end

    define_parser do |body|
      MultiJson.load body unless body.strip.empty?
    end

  end
end
