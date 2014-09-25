require 'hull/core_ext/hash'
require 'hull/client'
require 'hull/config'
require 'hull/entity'

module Hull
  extend Config
  class << self
    # Alias for Hull::Client.new
    #
    # @return [Hull::Client]
    def new(options={})
      Hull::Client.new(options)
    end

    def as(user)
      Hull::Client.new({ access_token: self.user_token(user) })
    end

    # Delegate to Hull::Client
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end

    def respond_to?(method, include_private=false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end

    def log msg, level=:debug
      Hull.logger.send(level.to_sym, "[hull:#{Hull.domain}] #{msg}") if Hull.logger && Hull.logger.respond_to?(level.to_sym)
    end
  end

end
