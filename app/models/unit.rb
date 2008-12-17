class Unit < ActiveRecord::Base
  validates_numericality_of :scale, :greater_than => 0

  def convert_quantity_to(quantity, unit)
    raise ArgumentError unless kind == unit.kind
    quantity * unit.scale / scale
  end

  def format(quantity)
    if quantity < 0
      raise ArgumentError, quantity
    end
    if quantity >= 1
      sprintf('%g %s', quantity, abbr)
    else
      smaller_units = Unit.find(:all, { :conditions => ['family = ? AND kind = ? AND scale > ?', family, kind, scale], :order => 'scale DESC' })
      smaller_units.each_with_index do |smaller_unit, i|
        larger_quantity = convert_quantity_to(quantity, smaller_unit)
        if larger_quantity >= 1 || i == smaller_units.length - 1
          return smaller_unit.format(larger_quantity)
        end
      end
    end
  end
end
