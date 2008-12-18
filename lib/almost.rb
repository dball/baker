require 'rational'

# Supplies methods for approximating numbers
module Almost
  EPSILON = 0.001

  module InstanceMethods

    # Return an Almost::Number object which has an approximate == method
    # This lets us write things like:
    #
    # 1.almost == 0.999
    #
    # It takes an epsilon which indicates the amount of variance allowed
    # between the numbers. An epsilon of 0.001, the default, indicates the
    # numbers must be 99.9% similar.
    def almost(epsilon = EPSILON)
      Almost::Number.new(self, epsilon)
    end

    # Returns the nearest rational fraction of the given denominator.
    # Assuming mathn is required, this means we can write things like:
    #
    # 0.5.nearest(1/4) == 1/2
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
  # Overrides rational to_s to take a format arguemnt. If supplied, and equal
  # to :split, renders the rational number as a whole number followed by the
  # fractional part:
  #
  # (7/4).to_s(:split) == "1 3/4"
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
