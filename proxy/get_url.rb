require_relative "proxy_io"

ProxyIO.send(:io).puts "\n"
fail unless ["press enter", "ready"] == ProxyIO.send(:wait_multiple_lines, 2)
STDERR.puts "proxy initialized successfully"

require_relative "lib/common_refinements.rb"
using Common::RefinementArray

(string, code) = ProxyIO.ensure_single_line ARGV.assert_one
fail code.inspect unless 200 == code
puts SimpleZlib.decode string
