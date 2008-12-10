class Unit < ActiveRecord::Base
  validates_numericality_of :scale, :greater_than => 0

  def convert_quantity_to(quantity, unit)
    raise ArgumentError unless kind == unit.kind
    quantity * unit.scale / scale
  end
end
