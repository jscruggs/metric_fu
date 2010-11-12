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
    # remove dependency on statarray
    # scores.to_statarray.mean
    score_length = scores.length
    sum = 0
    sum = scores.inject( nil ) { |sum,x| sum ? sum+x : x }
    (sum.to_f / score_length.to_f)
  end

  extend self
end
