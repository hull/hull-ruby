require 'addressable/uri'
require 'postrank-uri'

class Hull::Entity

  class InvalidUID < StandardError; end

  def self.valid_uri?(uri)
    Addressable::URI.parse(uri).domain
  rescue Addressable::URI::InvalidURIError
    false
  end

  def self.decode uid
    raise(InvalidUID, uid) unless uid.is_a?(String)
    if uid =~ /^~[a-z0-9_\-\+\/\=]+$/i && (uid.length - 1) % 4 == 0
      uid = uid.gsub(/^~/, '')
      begin
        if uid =~ /\/\+/
          uid = Base64.decode64(uid)
        else
          uid = Base64.urlsafe_decode64(uid)
        end
      rescue => err
        raise InvalidUID, err.message
      end
    end

    if valid_uri?(uid)
      uid = PostRank::URI.clean(uid)
    end

    begin
      uid.encode(Encoding::UTF_8)
    rescue => err
      raise InvalidUID, err.message
    end
  end

  def self.encode uid
    "~#{Base64.urlsafe_encode64(uid)}"
  end
end
