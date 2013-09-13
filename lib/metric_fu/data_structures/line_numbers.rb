# MetricFu::LineNumber
# (see #initialize)
require 'ruby_parser'
module MetricFu
  class LineNumbers
    Node = Struct.new(:sexp) do
      def nil?
        sexp.nil?
      end
      def node_type
        sexp[0]
      end
      def name
        sexp[1]
      end
      def each_of_type(type,node_class=Node)
        sexp.each_of_type(type) do |child_sexp|
          yield node_class.new(child_sexp)
        end
      end
      def each_module(&block)
        each_of_type(:module,&block)
      end
      def each_class(&block)
        each_of_type(:class,&block)
      end
      def each_singleton_class(&block)
        each_of_type(:sclass,SingletonMethodNode,&block)
      end
      def each_instance_method(&block)
        each_of_type(:defn,InstanceMethodNode,&block)
      end
      def each_class_method(&block)
        each_of_type(:defs,ClassMethodNode,&block)
      end
      def first_line
        sexp.line
      end
      def last_line
        sexp.last.line
      end
      def line_range
        (first_line..last_line)
      end
      def hide_methods_from_next_round(node)
        sexp.find_and_replace_all(:defn, :ignore_me)
        sexp.find_and_replace_all(:defs, :ignore_me)
      end
      def full_method_name(method_separator, class_name, module_name=nil)
        [module_namespace(module_name), class_name, method_separator, name].join
      end
      def module_namespace(module_name=nil)
        if module_name.nil?
          nil
        else
          [module_name,class_method_separator].join
        end
      end
      def instance_method_separator
        '#'
      end
      def class_method_separator
        '::'
      end
    end
    class ClassMethodNode < Node
      def name
        sexp[2]
      end
      def full_name(module_name, class_name)
        full_method_name(class_method_separator, class_name, module_name)
      end
    end
    class InstanceMethodNode < Node
      def full_name(module_name, class_name)
        full_method_name(instance_method_separator, class_name, module_name)
      end
    end
    class SingletonMethodNode < Node
      def full_name(class_name)
        full_method_name(class_method_separator, class_name)
      end
      def each_singleton_method(&block)
        each_of_type(:defn,SingletonMethodNode,&block)
      end
    end

    attr_reader :file_path

    # Parses ruby code to collect line numbers for class, module, and method definitions.
    # Used by metrics that don't provide line numbers for class, module, or methods problems
    # @param contents [String] a string of ruby code
    # @param file_path [String] the file path for the contents, defaults to empty string
    def initialize(contents,file_path='')
      @locations = {}
      @file_path = file_path
      parse_code(contents)
    end

    # @param line_number [String]
    # @return [Boolean] if the given line number is in a method
    def in_method? line_number
      !!@locations.detect do |method_name, line_number_range|
        line_number_range.include?(line_number)
      end
    end

    # @param line_number [Integer]
    # @return [String, nil] the method which includes that line number, if any
    # For all collected locations, find the first location where the line_number_range
    #   includes the line_number
    #   If a location is found, return its first element
    #   Else return nil
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

    # @param method [String] the method name being queried
    # @erturn [Integer, nil] the line number at which the given method is defined
    def start_line_for_method(method)
      return nil unless @locations.has_key?(method)
      @locations[method].first
    end

    private

    def parse_code(contents)
      if contents.to_s.size.zero?
        mf_log "NON PARSEABLE INPUT: File is empty at path #{file_path.inspect}\n\t#{caller.join("\n\t")}"
      else
        rp = RubyParser.new
        file_sexp = rp.parse(contents)
        file_sexp && process_ast(file_sexp)
      end
    rescue Exception => e
      #catch errors for files ruby_parser fails on
      mf_log "RUBY PARSE FAILURE: #{e.class}\t#{e.message}\tFILE:#{file_path}\tSEXP:#{file_sexp.inspect}\n\tCONTENT:#{contents.inspect}\n\t#{e.backtrace}"
    end

    def process_ast(file_sexp)
      node = Node.new(file_sexp)
      case node.node_type
      when nil
        mf_log "No ruby code found in #{file_path}"
      when :class
        process_class(node)
      when :module
        process_module(node)
      else
        mf_debug "SEXP: Parsing line numbers for classes in sexp type #{node.node_type.inspect}"
        mf_debug "      in #{file_path}"
        node.each_module {|child_node| process_class(child_node) }
        node.each_class  {|child_node| process_class(child_node) }
      end
    end

    def process_module(module_node)
      module_name = module_node.name
      module_node.each_class do |class_node|
        process_class(class_node, module_name)
        class_node.hide_methods_from_next_round
      end
      process_class(module_node)
    end

    def process_class(class_node, module_name=nil)
      class_name = class_node.name
      process_singleton_methods(class_node, class_name, module_name)
      process_instance_methods( class_node, class_name, module_name)
      process_class_methods(    class_node, class_name, module_name)
    end

    def process_singleton_methods(class_node, class_name, module_name)
      class_node.each_singleton_class do |singleton_node|
        singleton_node.each_singleton_method do |singleton_method_node|
          singleton_method_name = singleton_method_node.full_name(class_name)
          @locations[singleton_method_name] = singleton_method_node.line_range
        end
      end
    end

    def process_instance_methods(class_node, class_name, module_name)
      class_node.each_instance_method do |instance_method_node|
        instance_method_name = instance_method_node.full_name(module_name, class_name)
        @locations[instance_method_name] = instance_method_node.line_range
      end
    end

    def process_class_methods(class_node, class_name, module_name)
      class_node.each_class_method do |class_method_node|
        class_method_name = class_method_node.full_name(module_name, class_name)
        @locations[class_method_name] = class_method_node.line_range
      end
    end

  end
end
