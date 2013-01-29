module MetricFu
  module CarefulArray

    def carefully_remove(elements)
      missing_elements = elements - self
      raise "Cannot delete missing elements: #{missing_elements.inspect}" unless missing_elements.empty?
      (self - elements).extend(MetricFu::CarefulArray)
    end

  end
end
