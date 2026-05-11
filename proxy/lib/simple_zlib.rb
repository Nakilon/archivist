require "base64"
require "zlib"

module SimpleZlib
  def self.encode string
    fail ::ArgumentError unless string.is_a? ::String
    ::Base64.strict_encode64 ::Zlib::Deflate.deflate string.b
  end
  def self.decode base64_string
    ::Zlib::Inflate.inflate ::Base64.decode64 base64_string
  end
end
