module MetricFu
  class Record

    attr_reader :data

    def initialize(data, columns)
      @data = data
      @columns = columns
    end

    def method_missing(name, *args, &block)
      key = name.to_s
      if @data.has_key?(key)
        @data[key]
      elsif @columns.member?(key)
        nil
      else
        super(name, *args, &block)
      end
    end

    def []=(key, value)
       @data[key]=value
    end

    def [](key)
      @data[key]
    end

    def keys
      @data.keys
    end

    def has_key?(key)
      @data.has_key?(key)
    end

    def attributes
      @columns
    end

  end
end
