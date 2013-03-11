module MetricFu
  class HotspotProblems
    def initialize(grouping, details, exclude_details)
      @grouping, @details, @exclude_details = grouping, details, exclude_details
    end
    def problems
      problems = {}
      @grouping.each do |metric, table|
        if @details == :summary || @exclude_details.include?(metric)
          problems[metric] = present_group(metric,table)
        else
          problems[metric] = present_group_details(metric,table)
        end
      end
      problems
    end

    # TODO: As we get fancier, the presenter should
    # be its own class, not just a method with a long
    # case statement
    def present_group(metric, group)
      occurences = group.size
      case(metric)
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

    def present_group_details(metric, group)
      occurences = group.size
      case(metric)
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
      else
        raise MetricFu::AnalysisError, "Unknown metric #{metric}"
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
