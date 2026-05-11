STDOUT.sync = true
puts "press enter"
fail unless "\n" == gets
puts "ready"

require "nethttputils"
NetHTTPUtils.logger.instance_variable_set(:@logdev, STDERR)
get = lambda do |url|
  response = NetHTTPUtils.request_data url
  [Integer(response.instance_variable_get(:@last_response).code), SimpleZlib.encode(response)]
end

require "timeout"
require_relative "simple_zlib.rb"
require "json"
begin
  Timeout.timeout(16) do
    loop do
      break unless cmd = gets
      (mtd, encoded_url) = cmd.chomp.split(" ", 2)
      fail "bad format" unless mtd && encoded_url
      fail "unsupported mtd #{mtd.inspect}" unless "GET" == mtd
      (code, body) = get.(SimpleZlib.decode encoded_url)
      puts JSON.generate status: "success", body: SimpleZlib.encode(body), code: Integer(code)
    rescue
      puts JSON.generate status: "error", body: [$!, $!.backtrace].join("\n")
    end
  end
rescue Timeout::Error
end
