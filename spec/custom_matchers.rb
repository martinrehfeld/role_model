module CustomMatchers
  class ArrayIncludingMatcher
    def initialize(*expected)
      @expected = Array[*expected].flatten
    end

    def ==(actual)
      @expected.each do | value |
        return false unless actual.include?(value)
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
