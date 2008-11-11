module MetricFu::FlogReporter
  class Page < MetricFu::Base::Generator
    attr_accessor :score, :scanned_methods

    def initialize(score, scanned_methods = [])
      @score = score.to_f
      @scanned_methods = scanned_methods
    end

    def to_html
      ERB.new(File.read(template_file)).result(binding)
    end

    def average_score
      sum = 0
      scanned_methods.each do |m|
        sum += m.score
      end
      sum / scanned_methods.length
    end

    def highest_score
      scanned_methods.inject(0) do |highest, m|
        m.score > highest ? m.score : highest
      end
    end

    # should be dynamically read from the class
    def template_name
      'flog_page'
    end
  end
end