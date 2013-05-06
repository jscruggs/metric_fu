# TODO determine if this file should be deleted
# it doesn't appear to be used anywhere
require 'delegate'

# TODO remove explicit metric analyzer loading
[ 'hotspots/hotspot_analyzer',
  'flog/flog_hotspot',
  'saikuro/saikuro_hotspot',
  'churn/churn_hotspot',
  'reek/reek_hotspot',
  'flay/flay_hotspot'].each do |path|
  MetricFu.metrics_require { path }
end
# TODO determine if the careful_array is needed
%w(careful_array).each do |path|
  MetricFu.data_structures_require { path }
end
MetricFu.metrics_require   { "hotspots/analysis/record" }

module MetricFu
  class CodeIssue < DelegateClass(MetricFu::Record) #DelegateClass(Ruport::Data::Record)
    include Comparable

    # TODO: Yuck! 'stat_value' is a column for StatHotspot
    # TODO remove explicit metric references
    EXCLUDED_COLUMNS =
      FlogHotspot::COLUMNS +
      SaikuroHotspot::COLUMNS +
      ['stat_value'] +
      ChurnHotspot::COLUMNS +
      ReekHotspot.new.columns.extend(MetricFu::CarefulArray).carefully_remove(['reek__type_name',
      'reek__comparable_message']) +
      FlayHotspot.new.columns.extend(MetricFu::CarefulArray).carefully_remove(['flay_matching_reason'])

    def <=>(other)
      spaceship_for_columns(self.attributes, other)
    end

    def ===(other)
      self.hash_for(included_columns_hash, included_columns) == other.hash_for(included_columns_hash, included_columns)
    end

    def spaceship_for_columns(columns, other)
      columns.each do |column|
        equality = self[column].to_s <=> other[column].to_s
        return equality if equality!=0
      end
      return 0
    end

    def hash_for(column_hash, columns)
      @hashes ||= {}
      # fetch would be cleaner, but slower
      if @hashes.has_key?(column_hash)
        @hashes[column_hash]
      else
        values = columns.map {|column| self[column]}
        hash_for_columns = values.join('').hash
        @hashes[column_hash]=hash_for_columns
        hash_for_columns
      end
    end

    def included_columns_hash
      @included_columns_hash ||= included_columns.hash
    end

    def included_columns
      @included_columns ||= self.attributes.extend(MetricFu::CarefulArray).carefully_remove(EXCLUDED_COLUMNS)
    end

    def find_counterpart_index_in(collection)
      # each_with_index is cleaner, but it is slower and we
      # spend a lot of time in this loop
      index = 0
      collection.each do |issue|
        return index if self === issue
        index += 1
      end
      return nil
    end

    # TODO remove explicit metric references
    def modifies?(other)
      case self.metric
      when :reek
        #return false unless ["Large Class", "Long Method", "Long Parameter List"].include?(self.reek__type_name)
        return false if self.reek__type_name != other.reek__type_name
        self.reek__value != other.reek__value
      when :flog
        self.score != other.score
      when :saikuro
        self.complexity != other.complexity
      when :stats
        self.stat_value != other.stat_value
      when :churn
        self.times_changed != other.times_changed
      when :flay
        #self.flay_reason != other.flay_reason
        # do nothing for now
      when :roodi, :stats
        # do nothing
      else
        raise ArgumentError, "Invalid metric type #{self.metric}"
      end
    end

  end
end
