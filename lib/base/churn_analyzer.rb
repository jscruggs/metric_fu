class ChurnAnalyzer
  include ScoringStrategies

  COLUMNS = %w{times_changed}

  def columns
    COLUMNS
  end
  
  def name
    :churn
  end

  def map(row)
    ScoringStrategies.present(row)
  end

  def reduce(scores)
    ScoringStrategies.sum(scores)
  end

  def score(metric_ranking, item)
    flat_churn_score = 0.50
    metric_ranking.scored?(item) ? flat_churn_score : 0
  end
  
  def generate_records(data, table)
   return if data==nil
    Array(data[:changes]).each do |change|
      table << {
        "metric" => :churn,
        "times_changed" => change[:times_changed],
        "file_path" => change[:file_path]
      }
    end
  end

  private 

  def self.update_changes(total, changed)
    changed.each do |change|
      #should work as has_key(change), but hash == doesn't work on 1.8.6 here for some reason it never matches
      if total.has_key?(change.to_a.sort)
        total[change.to_a.sort] += 1
      else
        total[change.to_a.sort] = 1
      end
    end
    total
  end

end
