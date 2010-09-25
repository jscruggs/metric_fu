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

  def self.churn_history(source, api_url, github_login, github_token, revision_count)
    project = ProjectResource.new(
                                  source.uri, 
                                  api_url,
                                  :github_login => github_login,
                                  :github_token => github_token)
    revisions         = project.cached_reverse_revisions(revision_count)
    revisions_metrics = project.get_revision_metrics(revisions, 'churn')
    revisions_changes = { :klasses => {}, :methods => {}}
    
    revisions_metrics.each do |metric|
      revision = metric.first
      metric_data = metric.last
      metric_data = metric_data[:churn] if metric_data
      if metric_data
        changed_classes = metric_data[:changed_classes]
        changed_methods = metric_data[:changed_methods]
        klasses = revisions_changes[:klasses]
        methods = revisions_changes[:methods]
        klasses = update_changes(klasses, changed_classes) if changed_classes
        methods = update_changes(methods, changed_methods) if changed_methods
      end
    end

    churn_data_points = revisions_metrics.length
    [revisions_changes, churn_data_points]
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
