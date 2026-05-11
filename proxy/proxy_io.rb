require_relative "lib/common_refinements.rb"
using ::Common::RefinementArray

module ProxyIO
  require "io/wait"
  private_class_method def self.io
    @io ||= ::IO.popen "ssh -T node \"docker run --rm -i -v \\$(pwd)/proxy/main.rb:/main.rb -v \\$(pwd)/proxy/simple_zlib.rb:/simple_zlib.rb proxy ruby main.rb\"", "r+"
  end

  require "timeout"
  # stops polling when server does not emit new lines for 4 seconds straight
  private_class_method def self.read_response timeout = 4
    server_timeout = 16   # KEEP IN SYNC WITH server_proxy.rb
    fail "too big #wait_readable timeout (#{timeout} sec), should be <= #{server_timeout} (server timeout) / 4" if server_timeout < 4 * timeout
    [].tap do |response_array|
      ::Timeout.timeout(2 * timeout) do
        loop do
          break ::STDERR.puts "no new line in #{timeout} sec" unless io.wait_readable timeout
          fail "EOF" if io.eof?
          fail "WTF: EOF but not EOF?" unless line = io.gets
          response_array.push line.chomp
        end
      end
    end
  end

  require_relative "lib/simple_zlib"
  require "json"
  def self.get url
    mtd = "GET"
    io.puts "#{mtd} #{::SimpleZlib.encode url}"
    json = ::JSON.parse read_response.assert_one{ |_| "response size: #{_.size}" }
    case json["status"]
    when "success"
      [json["code"], ::SimpleZlib.decode(json["body"])]
    when "error"
      puts json["body"]
      fail "server error"
    else
      fail "bad status #{json["status"].inspect}"
    end
  end

end
