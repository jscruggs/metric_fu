module MetricFu

  def self.graph
    @graph ||= Graph.new
  end

  class Graph
    
    attr_accessor :clazz
    
    def initialize
      self.clazz = []
    end
    
    def add(graph_type)
      grapher_name = graph_type.to_s.capitalize + "Grapher"
      self.clazz.push MetricFu.const_get(grapher_name).new
    end
    
    
    def generate
      return if self.clazz.empty?
      puts "Generating graphs"
      Dir[File.join(MetricFu.data_directory, '*.yml')].sort.each do |metric_file|
        puts "Generating graphs for #{metric_file}"
        date = metric_file.split('/')[3].split('.')[0]
        metrics = YAML::load(File.open(metric_file))
        
        self.clazz.each do |grapher|
          grapher.get_metrics(metrics, date)
        end
      end
      self.clazz.each do |grapher|
        grapher.graph!
      end
    end
  end
end