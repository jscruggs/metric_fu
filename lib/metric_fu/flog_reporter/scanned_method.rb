module MetricFu::FlogReporter
  class ScannedMethod
    attr_accessor :name, :score, :operators
    
    def initialize(name, score, operators = [])
      @name = name
      @score = score.to_f
      @operators = operators
    end
    
    def to_html
      output = "<p><strong>#{name} (#{score})</strong></p>\n"
      output << "<table>\n"
      output << "<tr><th>Score</th><th>Operator</th></tr>\n"
      count = 0
      operators.each do |operator|
        output << <<-EOF
                    <tr class='#{Base.cycle("light", "dark", count)}'>
                      <td class='score'>#{sprintf(SCORE_FORMAT, operator.score)}</td>
                      <td class='score'>#{operator.operator}</td>
                    </tr>
                  EOF
        count += 1
      end
      output << "</table>\n\n"
    end
  end
end