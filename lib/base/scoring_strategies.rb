#TODO HOTSPOTS just implement the mean function to remove the statarray requirements
require 'statarray'

module ScoringStrategies

  def percentile(ranking, item)
    ranking.percentile(item)
  end
  
  def identity(ranking, item)
    ranking[item]
  end

  def present(row)
    1
  end

  def sum(scores)
    scores.inject(0) {|s,x| s+x}
  end

  def average(scores)
    begin
      scores.to_statarray.mean
    rescue => error
      error
    end
  end
  
  extend self
end
