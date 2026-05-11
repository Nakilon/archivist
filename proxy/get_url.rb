require_relative "proxy_io"

ProxyIO.send(:io).puts "\n"
fail unless ["press enter", "ready"] == ProxyIO.send(:read_response, 2)
STDERR.puts "proxy initialized successfully"

require_relative "lib/common_refinements.rb"
using Common::RefinementArray

(code, string) = ProxyIO.get ARGV.assert_one
fail unless 200 == code
puts SimpleZlib.decode string
