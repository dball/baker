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
        # This is a hokey way of doing this, but value.scalar is giving
        # imprecise results covnerting oucnes to pounds, and I don't eel
        # like rounding to X significant figures just yet.
        md = /^(\d+)(\.\d+)? /.match(s = value.to_s)
        whole = md[1].to_i
        part = md.length == 3 ? md[2].to_f : 0
        if whole == 0 && part == 0
        elsif unit != last
          if whole > 0
            parts << sprintf('%d %s', whole, value.units)
          end
          value = Unit(sprintf('%f %s', part, value.units))
        else
          frac = value.scalar.nearest(1/8)
          if frac == 0
            parts << value.to_s
          else
            frac = (frac.is_a?(Rational) ? frac.to_s(:split) : frac.to_s)
            parts << sprintf('%s %s', frac, value.units)
          end
        end
      end
      parts.join(' ')
    end
  end
end
