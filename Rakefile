task :default do
  FileList.glob("resources/*.rb").each do |file|
    fail unless /\A[a-z]+\z/ =~ (name = File.basename(file, ".rb"))

    data_dir = "datas/#{name}/data"
    FileUtils.rm_rf data_dir
    FileUtils.mkdir_p data_dir
    ruby "-r #{File.expand_path file} -C./#{data_dir} -e dump"

    ruby "-r #{File.expand_path "filetree"} -r #{File.expand_path file} -C./datas/#{name} -e compile"

  end
end
