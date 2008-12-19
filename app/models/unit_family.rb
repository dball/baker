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
    unit = value.to(@units.first)
    if output_format == :fraction
      scalar = unit.scalar.nearest(1/8)
      if scalar == 0
        unit.to_s
      else
        scalar = (scalar.is_a?(Rational) ? scalar.to_s(:split) : scalar.to_s)
        scalar + ' ' + unit.units
      end
    else
      sprintf('%.3g %s', unit.scalar, unit.units)
    end
  end
end
