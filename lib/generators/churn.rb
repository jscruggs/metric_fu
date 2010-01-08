module MetricFu

  class Churn < Generator

    def initialize(options={})
      super
    end

    def self.verify_dependencies!
      result = `churn --help`
      raise 'sudo gem install churn # if you want the churn tasks' unless result.match(/churn/)
    end

    
    def emit
      @output = `churn --yaml`
      yaml_start = @output.index("---")
      @output = @output[yaml_start...@output.length]
    end

    def analyze
      @churn = YAML::load(@output)
    end

    def to_h
      {:churn => @churn[:churn]}
    end
  end

end
