require_relative "proxy_io"
ProxyIO.init

require_relative "lib/common_refinements.rb"

using Common::RefinementArray
ProxyIO.send(:io).puts "GET #{SimpleZlib.encode ARGV.assert_one}"

using Common::RefinementString
lines = ProxyIO.send(:wait_multiple_lines)
puts "total lines: #{lines.size}"
for line in lines
  string, code = ProxyIO.send(:unpack_line, line)
  puts "#{code.inspect} #{string.inspect.shorten}"
end
