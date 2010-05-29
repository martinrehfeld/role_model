module CustomMatchers
  class ArrayIncludingMatcher
    def initialize(*expected)
      @expected = Array[*expected]
    end

    def ==(actual)
      return false if actual.size < @expected.size
      @expected.each do | value |
        return false unless actual.any? { |actual_value| value == actual_value }
      end
      true
    rescue NoMethodError => ex
      return false
    end

    def description
      "array_including(#{@expected.inspect.sub(/^\[/,"").sub(/\]$/,"")})"
    end
  end

  def array_including(*args)
    ArrayIncludingMatcher.new(*args)  
  end
end
