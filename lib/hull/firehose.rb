module Hull
  # Defines HTTP request methods
  module Firehose
    
    # Perform an HTTP DELETE request
    def track(event, properties={}, context={}, options={})
      ctx = { ip: 0, url: nil, referer: nil }.merge(context)
      firehose_request([{
        type: 'track',
        body: ctx.merge({ event: event, properties: properties })
      }], options)
    end

    # Perform an HTTP GET request
    def traits(traits, options={})
      firehose_request([{
        type: 'traits',
        body: traits
      }], options)
    end

    # Perform an HTTP POST request
    def alias(body, options={})
      firehose_request([{
        type: 'alias',
        body: body
      }], options)
    end

    private

    def firehose_url
      "https://firehose.#{organization.split(".", 2)[1,2].first}"
    end
    
    def firehose_connection
      opts = {
        :headers => {
          :accept => 'application/json',
          :user_agent => user_agent,
        },
        url: firehose_url
      }
      Faraday.new(opts) do |builder|
        builder.use Hull::Request::Auth, credentials
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Response::RaiseError
        builder.adapter(adapter)
      end
    end

    # Perform an HTTP request
    def firehose_request(batch={}, options={})
      raise "MissingAccessTokenError" if credentials[:access_token].nil?
        headers = {
          'Hull-Access-Token' => credentials[:access_token]
        }

        body = { 
          batch: batch.map { |b| b.merge(headers: headers, timestamp: Time.now) }, 
          timestamp: Time.now.utc, 
          sentAt: Time.now.utc 
        }


      response = firehose_connection.post do |request|
        request.headers['Content-Type'] = 'application/json'
        request.url '/'
        request.body = MultiJson.dump(body)
        if request.options.is_a?(Hash)
          request.options[:timeout]       ||= options.fetch(:timeout, 10)
          request.options[:open_timeout]  ||= options.fetch(:open_timeout, 10)
        elsif request.options.respond_to?(:timeout)
          request.options.timeout         ||= options.fetch(:timeout, 10)
          request.options.open_timeout    ||= options.fetch(:open_timeout, 10)
        end
      end
      response
    end

  end
end
