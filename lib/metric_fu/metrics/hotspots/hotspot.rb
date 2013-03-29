module MetricFu
  class Hotspot
    def self.metric
      self.name.split('Hotspot')[0].downcase.to_sym
    end
    @analyzers = {}
    def self.analyzers
      @analyzers.values
    end
    def self.analyzer_for_metric(metric)
      mf_debug "Getting analyzer for #{metric}"
      @analyzers.fetch(metric.to_sym) {
        raise MetricFu::AnalysisError, "Unknown metric #{metric}. We only know #{@analyzers.keys.inspect}"
      }
    end
    def self.inherited(subclass)
      mf_debug "Adding #{subclass} to #{@analyzers.inspect}"
      @analyzers[subclass.metric] = subclass.new
    end
    # TODO: As we get fancier, the presenter should
    # be its own class, not just a method with a long
    # case statement
    def present_group(group)
      occurences = group.size
      case(self.name)
      when :reek
        "found #{occurences} code smells"
      when :roodi
        "found #{occurences} design problems"
      when :churn
        "detected high level of churn (changed #{group[0].times_changed} times)"
      when :flog
        complexity = get_mean(group.column("score"))
        "#{"average " if occurences > 1}complexity is %.1f" % complexity
      when :saikuro
        complexity = get_mean(group.column("complexity"))
        "#{"average " if occurences > 1}complexity is %.1f" % complexity
      when :flay
        "found #{occurences} code duplications"
      when :rcov
        average_code_uncoverage = get_mean(group.column("percentage_uncovered"))
        "#{"average " if occurences > 1}uncovered code is %.1f%" % average_code_uncoverage
      else
        raise MetricFu::AnalysisError, "Unknown metric #{metric}"
      end
    end

    def present_group_details(group)
      occurences = group.size
      case(self.name)
      when :reek
        message = "found #{occurences} code smells<br/>"
        group.each do |item|
          type    = item.data["reek__type_name"]
          reek_message = item.data["reek__message"]
          message << "* #{type}: #{reek_message}<br/>"
        end
        message
      when :roodi
        message = "found #{occurences} design problems<br/>"
        group.each do |item|
          problem    = item.data["problems"]
          message << "* #{problem}<br/>"
        end
        message
      when :churn
        "detected high level of churn (changed #{group[0].times_changed} times)"
      when :flog
        complexity = get_mean(group.column("score"))
        "#{"average " if occurences > 1}complexity is %.1f" % complexity
      when :saikuro
        complexity = get_mean(group.column("complexity"))
        "#{"average " if occurences > 1}complexity is %.1f" % complexity
      when :flay
        message = "found #{occurences} code duplications<br/>"
        group.each do |item|
          problem    = item.data["flay_reason"]
          problem    = problem.gsub(/^[0-9]*\)/,'')
          problem    = problem.gsub(/files\:/,' <br>&nbsp;&nbsp;&nbsp;files:')
          message << "* #{problem}<br/>"
        end
        message
      end
    end

    # TODO simplify calculation
    def get_mean(collection)
      collection_length = collection.length
      sum = 0
      sum = collection.inject( nil ) { |sum,x| sum ? sum+x : x }
      (sum.to_f / collection_length.to_f)
    end
  end
end
