module MetricFu
  class Hotspot
    @analyzer_tools = []
    def self.analyzers
      @analyzer_tools
    end
    def self.inherited(subclass)
      mf_debug "Adding #{subclass} to #{@analyzer_tools.inspect}"
      @analyzer_tools << subclass.new
    end
  end
end
