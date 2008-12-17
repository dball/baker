require 'rational'

module Almost
  EPSILON = 0.001

  module InstanceMethods
    def almost(epsilon = EPSILON)
      Almost::Number.new(self, epsilon)
    end
  end

  class Number
    def initialize(value, epsilon)
      @value = value
      @epsilon = epsilon
    end

    def ==(other)
      max = (@value.abs > other.abs ? @value : other)
      (fr, exp) = Math.frexp(max)
      delta = Math.ldexp(@epsilon, exp)
      if (difference = @value - other) < 0
        difference >= -delta
      else
        difference <= delta
      end
    end
  end
end

class Numeric
  include Almost::InstanceMethods
end
