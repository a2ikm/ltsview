module Ltsview
  class Parse

    def initialize(options)
      @color = true
      @ltsv = option_parse options
    end

    def print
      $stdin.each_line do |line|
        puts "---"
        LTSV.parse(line.chomp).each do |key,val|
          puts color key,val if keys?(key) && !ignore?(key)
        end
      end
    end

    private
     def option_parse(options)
       option = OptionParser.new
       option.on('-f', '--file VAL'){ |v| @file = v }
       option.on('-k', '--keys VAL'){ |v| @keys = v.split(',') }
       option.on('-i', '--ignore-key VAL'){ |v| @ignore_key = v.split(',') }
       option.on('--[no-]colors'){ |v| @color = v }
       option.permute!(options)
       options
     end

     def file_load(file_path)
       stream = File.open(file_path, 'r')
       LTSV.parse(stream)
     end

     def keys?(key)
       @keys.nil? || @keys.include?(key.to_s)
     end

     def ignore?(key)
       !@ignore_key.nil? && @ignore_key.include?(key.to_s)
     end

     def color(key, val)
       @color ? "#{key.to_s.magenta}: #{val.cyan}" : "#{key}: #{val}"
     end

  end
end
