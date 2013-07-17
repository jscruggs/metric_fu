module MetricFu
  module MetricVersion
    extend self

    # @return rcov version if running rcov
    def rcov
      ['~> 0.8']
    end

    def method_missing(method,*args,&block)
      if (gem_version = version_for(method.to_s))
        gem_version
      else
        super
      end
    end

    private

    def ast
      require 'ruby_parser'
      parser = RubyParser.new
      gemspec = File.read(File.expand_path('../../metric_fu.gemspec', __FILE__))
      ast = parser.parse(gemspec)
    end

    def gems
      @gems ||= ast.find{|node| node[0] == :iter}.
        find{|node| node[0] == :block}.
        select{|node| node[0] == :call }.
        select{|node| node[2] == :add_runtime_dependency }.
        map{|node| [
          node[3][1].downcase.sub('metric_fu-',''),
          Array(Array(node[4])[1..-1]).map{|node|node[1]}
        ]}
    end

    # @return nil if no gem found
    # @return Array<String> where the strings are valid gem version requires
    def version_for(gem_name)
      node = gems.find{|node|node[0] == gem_name.downcase}
      node && node[1]
    end
  end
end
