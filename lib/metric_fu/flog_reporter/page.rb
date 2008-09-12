module MetricFu::FlogReporter
  class Page
    attr_accessor :score, :scanned_methods
    
    def initialize(score, scanned_methods = [])
      @score = score.to_f
      @scanned_methods = scanned_methods
    end
    
    def to_html
      output = "<html><head><style>"
      output << Base.load_css
      output << "</style></head><body>"
      output << "Score: #{score}\n"
      scanned_methods.each do |sm|
        output << sm.to_html
      end
      output << "</body></html>"
      output
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
  end
end