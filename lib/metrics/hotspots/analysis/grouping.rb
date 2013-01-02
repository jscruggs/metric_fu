%w(table).each do |path|
  MetricFu.metrics_require   { "hotspots/analysis/#{path}" }
end
module MetricFu
  class Grouping

    def initialize(table, opts)
      column_name = opts.fetch(:by)
      order = opts.fetch(:order) { nil }
      hash = {}
      if column_name.to_sym == :metric # special optimized case
        hash = table.group_by_metric
      else
        table.each do |row|
          hash[row[column_name]] ||= MetricFu::Table.new(:column_names => row.attributes)
          hash[row[column_name]] << row
        end
      end
      if order
        @arr = hash.sort_by(&order)
      else
        @arr = hash.to_a
      end
    end

    def [](key)
      @arr.each do |group_key, table|
        return table if group_key == key
      end
      return nil
    end

    def each
      @arr.each do |value, rows|
        yield value, rows
      end
    end

  end
end
