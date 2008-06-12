require 'digest/md5'
require 'fileutils'

module Metricks
  class MD5Tracker

    @@unchanged_md5s = []

    class << self
      def md5_dir(path_to_file)
        File.join(Metricks::BASE_DIRECTORY,
                  path_to_file.split('/')[0..-2].join('/'))        
      end

      def md5_file(path_to_file)
        File.join(md5_dir(path_to_file),    
                  path_to_file.split('/').last.sub(/\.[a-z]+/, '.md5'))
      end
      
      def track(path_to_file)
        md5 = Digest::MD5.hexdigest(File.read(path_to_file))
        FileUtils.mkdir_p(md5_dir(path_to_file), :verbose => false)
        f = File.new(md5_file(path_to_file), "w")
        f.puts(md5)
        f.close
        md5
      end
      
      def file_changed?(path_to_file)
        orig_md5_file = md5_file(path_to_file)
        unless File.exist?(orig_md5_file)
          track(path_to_file)
          return true
        end


        current_md5 = ""
        file = File.open(orig_md5_file, 'r')
        file.each_line { |line| current_md5 << line }
        file.close
        current_md5.chomp!
        
        new_md5 = Digest::MD5.hexdigest(File.read(path_to_file))
        new_md5.chomp!

        @@unchanged_md5s << path_to_file if new_md5 == current_md5

        return new_md5 != current_md5
      end
  
      def file_already_counted?(path_to_file)
        return @@unchanged_md5s.include?(path_to_file)
      end
    end
  end
end