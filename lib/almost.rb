require 'rational'

# Supplies methods for approximating numbers
#
# 2.almost == 1.999
# 0.75001.nearest(1/4) == 3/4
module Almost
  EPSILON = 0.001

  module InstanceMethods
    def almost(epsilon = EPSILON)
      Almost::Number.new(self, epsilon)
    end

    def nearest(fraction)
      unless fraction.is_a?(Rational) && fraction.numerator == 1
        raise ArgumentError, fraction 
      end
      (whole, part) = divmod(1)
      numerator = (part / fraction).round
      Rational(whole * fraction.denominator + numerator, fraction.denominator)
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

class Rational
  def to_s_with_format(format = nil)
    if format.nil?
      to_s_without_format
    elsif format == :split
      if numerator > denominator
        (whole, part) = divmod(1)
        whole.to_s + ' ' + part.to_s_without_format
      else
        to_s_without_format
      end
    else
      raise ArgumentError, format
    end
  end

  alias_method :to_s_without_format, :to_s
  alias_method :to_s, :to_s_with_format
end
