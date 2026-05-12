def dump
  require_relative "../proxy/proxy_io.rb"
  ProxyIO.init
  (0..).each do |i|
    fail if 100 <= i
    break if (0..).lazy.map do |j|
      fail if 100 <= j
      (string, code) = ProxyIO.fast_get(
        "https://regular-main-branch-middle.acidflow.stream/maps/regular-main-branch-middle/regular-main-branch-middle-2024-08-12-78633191_files/"\
        "11/#{i}_#{j}.webp", 60
      )
      next unless code
      File.binwrite ("%02d%02d.webp" % [i, j]), string
    end.take_while(&:itself).to_a.empty?
  end
end

def compile
  puts FileTree.new "data"
  return
end
