require_relative "lib/common_refinements.rb"
using ::Common::RefinementArray

module ProxyIO
  require "io/wait"
  private_class_method def self.io
    @io ||= ::IO.popen "ssh -T node \"docker run --rm -i -v \\$(pwd)/proxy/main.rb:/main.rb -v \\$(pwd)/proxy/Gemfile:/Gemfile -v \\$(pwd)/proxy/simple_zlib.rb:/simple_zlib.rb proxy sh -c \\\"bundle install --quiet && bundle exec ruby main.rb\\\"\"", "r+"
  end

  SERVER_TIMEOUT = 512   # KEEP IN SYNC WITH server_proxy.rb
  private_constant :SERVER_TIMEOUT
  require "timeout"


  private_class_method def self.single_line timeout = 4
    fail "too big #wait_readable timeout (#{timeout} sec), should be <= #{SERVER_TIMEOUT} (server timeout) / 4" if SERVER_TIMEOUT < 4 * timeout
    ::Timeout.timeout(2 * timeout) do
      fail "timeout (after #{timeout} sec)" unless io.wait_readable timeout
      fail "EOF" unless line = io.gets
      line.chomp
    end
  end

  def self.init
    fail unless "press enter" == single_line(7)    # this needs bigger timeout when with 'bundle install'
    io.puts "\n"
    fail unless "ready" == single_line
  end


  # stops polling when server does not emit new lines for 4 seconds straight
  private_class_method def self.wait_multiple_lines timeout = 4
    fail "too big #wait_readable timeout (#{timeout} sec), should be <= #{SERVER_TIMEOUT} (server timeout) / 4" if SERVER_TIMEOUT < 4 * timeout
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

  private_class_method def self.unpack_line json_string
    json = ::JSON.parse json_string
    case json["status"]
    when "success"
      [::SimpleZlib.decode(json["body"]), json["code"]]
    when "error"
      "server error: #{json["body"]}"
    else
      fail "bad status #{json["status"].inspect}"
    end
  end

  def self.ensure_single_line url
    mtd = "GET"
    io.puts "#{mtd} #{::SimpleZlib.encode url}"
    unpack_line wait_multiple_lines.assert_one
  end


  def self.fast_get url, timeout = nil
    io.puts "GET #{SimpleZlib.encode url}"
    unpack_line single_line(*timeout)
  end

end
