class FlogAnalyzer
  include ScoringStrategies

  COLUMNS = %w{score}

  def columns
    COLUMNS
  end
  
  def name
    :flog
  end
  
  def map(row)
    row.score
  end

  def reduce(scores)
    ScoringStrategies.average(scores)
  end

  def score(metric_ranking, item)
    ScoringStrategies.identity(metric_ranking, item)
  end
  
  def generate_records(data, table)
    return if data==nil
    Array(data[:pages]).each do |page|
      file_path = page[:path].sub(%r{^/},'')
      Array(page[:scanned_methods]).each do |entry|
        location = Location.for(entry[:name])
        table << {
          "metric" => name,
          "score" => entry[:score],
          "file_path" => file_path,
          "class_name" => location.class_name,
          "method_name" => location.method_name
        }
      end
    end
  end

end
