require 'ruby_parser'
module MetricFu
  class LineNumbers

    def initialize(contents,file_path='')
      if contents.to_s.size.zero?
        puts "NON PARSEABLE INPUT: File is empty at path #{file_path.inspect}\n\t#{caller.join("\n\t")}"
      else
        rp = RubyParser.new
        @locations = {}
        file_sexp = rp.parse(contents)
        case file_sexp[0]
        when :class
          process_class(file_sexp)
        when :module
          process_module(file_sexp)
        when :block
          file_sexp.each_of_type(:class) { |sexp| process_class(sexp) }
        else
          puts "Unexpected sexp_type #{file_sexp[0].inspect}"
        end
      end
    rescue Exception => e
      #catch errors for files ruby_parser fails on
      puts "RUBY PARSE FAILURE: #{e.class}\t#{e.message}\tCONTENT:#{contents.inspect}\SEXP:#{file_sexp.inspect}\tn#{e.backtrace}"
      @locations
    end

    def in_method? line_number
      !!@locations.detect do |method_name, line_number_range|
        line_number_range.include?(line_number)
      end
    end

    def method_at_line line_number
      found_method_and_range = @locations.detect do |method_name, line_number_range|
        line_number_range.include?(line_number)
      end
      if found_method_and_range
        found_method_and_range.first
      else
        nil
      end
    end

    def start_line_for_method(method)
      return nil unless @locations.has_key?(method)
      @locations[method].first
    end

    private

    def process_module(sexp)
      module_name = sexp[1]
      sexp.each_of_type(:class) do |sexp|
        process_class(sexp, module_name)
        hide_methods_from_next_round(sexp)
      end
      process_class(sexp)
    end

    def process_class(sexp, module_name=nil)
      class_name = sexp[1]
      process_class_self_blocks(sexp, class_name)
      module_name_string = module_name ? "#{module_name}::" : nil
      sexp.each_of_type(:defn) { |s| @locations["#{module_name_string}#{class_name}##{s[1]}"] = (s.line)..(s.last.line) }
      sexp.each_of_type(:defs) { |s| @locations["#{module_name_string}#{class_name}::#{s[2]}"] = (s.line)..(s.last.line) }
    end

    def process_class_self_blocks(sexp, class_name)
      sexp.each_of_type(:sclass) do |sexp_in_class_self_block|
        sexp_in_class_self_block.each_of_type(:defn) { |s| @locations["#{class_name}::#{s[1]}"] = (s.line)..(s.last.line) }
        hide_methods_from_next_round(sexp_in_class_self_block)
      end
    end

    def hide_methods_from_next_round(sexp)
      sexp.find_and_replace_all(:defn, :ignore_me)
      sexp.find_and_replace_all(:defs, :ignore_me)
    end

  end
end
