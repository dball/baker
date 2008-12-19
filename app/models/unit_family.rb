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
end
