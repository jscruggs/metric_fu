module MetricFu
  module MetricVersion
    extend self

    # @return rcov version if running rcov
    def rcov
      ['~> 0.8']
    end

    def method_missing(method,*args,&block)
      if (gem_version = version_for(method.to_s))
        gem_version != '' ? gem_version : nil
      else
        super
      end
    end

    private

    # Reads in the gemspec and parses out gem dependencies and versions, if specified
    # @return Array<Array<gem_name,gem_version>>, where both gem_name and gem_version are strings
    def gems
      @gems ||= begin
                  gemspec = File.readlines(File.expand_path('../../metric_fu.gemspec', __FILE__))
                  gemspec.select{|line| line =~ /dependency/}.map{|line|
                    line.scan(/dependency\s+['"](\S+)['"][^\['"]+([^$]+)?/)
                    gem_name = $1
                    if gem_name
                      gem_version = $2.to_s.chomp
                      [gem_name.to_s.downcase.sub('metric_fu-',''), gem_version]
                    end
                  }.compact
                end
    end

    # @return '' if no gem version found
    # @return Array<String> where the strings are valid gem version requires
    def version_for(gem_name)
      node = gems.find{|node|node[0] == gem_name.downcase}
      node && node[1]
    end
  end
end
