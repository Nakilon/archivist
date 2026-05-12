module FileTree
  cls = Class.new do
    def initialize path
      @path = ::File.expand_path path
    end
    def name
      ::File.basename @path
    end
    require "shellwords"
  end
  class Dir < cls
    def children
      ::Dir.children(@path).sort.map{ |_| ::FileTree.new ::File.expand_path _, @path }
    end
    def to_s
      "#{::Shellwords.shellescape name}(#{children.join ", "})"
    end
  end
  class File < cls
    def content
      ::File.binread @path
    end
    def to_s
      "#{::Shellwords.shellescape name}(size: #{content.size})"
    end
  end

  def self.new path
    if ::File.directory? path
      Dir
    elsif ::File.file? path
      File
    else
      fail "not supported file system node #{::File.expand_path path}"
    end.new path
  end
end
