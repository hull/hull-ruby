require 'faraday'
require 'hull/request/auth'
require 'hull/response/parse_json'
require 'faraday_middleware/response/parse_json'
require 'faraday_middleware/response/caching'

module Hull
  module Connection
  private

    # Returns a Faraday::Connection object
    #
    # @param options [Hash] A hash of options
    # @return [Faraday::Connection]
    def build_connection(options)
      Faraday.new(options) do |builder|
        builder.use Hull::Request::Auth, credentials
        builder.use Hull::Response::ParseJson
        builder.use Faraday::Response::RaiseError
        builder.adapter(adapter)
      end
    end

    def connection(options)
      build_connection({
        :headers => {
          :content_type => 'application/json',
          :accept => 'application/json',
          :user_agent => user_agent
        }
      }.merge(options))
    end

  end
end
