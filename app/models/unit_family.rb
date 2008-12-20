class UnitFamily
  OUTPUT_FORMATS = [:fraction, :decimal]

  attr_reader :name, :units, :output_format

  def initialize(name, units, output_format)
    raise ArgumentError unless !name.nil?
    @name = name
    @units = units.map {|unit| Unit(unit) }
    raise ArgumentError unless OUTPUT_FORMATS.include?(output_format)
    @output_format = output_format
  end

  def include?(unit)
    units.map {|units| units.units}.include?(unit)
  end

  def format(value)
    if output_format == :decimal
      value = value.to(units.last)
      sprintf('%.3g %s', value.scalar, value.units)
    else
      last = @units.last
      parts = []
      @units.each do |unit|
        value = value.to(unit)
        if value.scalar == 0
        elsif unit != last
          (whole, part) = value.scalar.divmod(1)
          if whole > 0
            value.scalar = whole
            parts << sprintf('%d %s', whole, value.units)
          end
          value = Unit(sprintf('%f %s', part, value.units))
        else
          scalar = value.scalar.nearest(1/8)
          if scalar == 0
            parts << value.to_s
          else
            scalar = (scalar.is_a?(Rational) ? scalar.to_s(:split) : scalar.to_s)
            parts << sprintf('%s %s', scalar, value.units)
          end
        end
      end
      parts.join(' ')
    end
  end
end
