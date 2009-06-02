require 'graph'
require 'gruff'
module MetricFu
  
  class ReekGrapher
    
    attr_accessor :reek_count, :labels
    
    def initialize
      self.reek_count = {}
      self.labels= {}
    end
    
    def get_metrics(metrics, date)
      counter = self.labels.size
      self.labels.update( { counter => date })
      
      metrics[:reek][:matches].each do |reek_chunk|
        reek_chunk[:code_smells].each do |code_smell|
          # speaking of code smell...
          self.reek_count[code_smell[:type]] = [] if self.reek_count[code_smell[:type]].nil?
          self.reek_count[code_smell[:type]][counter].nil? ? self.reek_count[code_smell[:type]][counter] = 1 : self.reek_count[code_smell[:type]][counter] += 1
        end
      end
    end
    
    def graph!
      g = Gruff::Line.new("1024x768")
      g.title = "Reek: code smells"
      g.theme = MetricFu.graph_theme
      g.font = MetricFu.graph_font
      self.reek_count.each_pair do |type, count|
        g.data(type, count)
      end
      g.labels = self.labels
      g.write(File.join(MetricFu.output_directory, 'reek.png'))
    end
    
  end
  
end
