class Unit < ActiveRecord::Base
  validates_numericality_of :scale, :greater_than => 0

  def convert_quantity_to(quantity, unit)
    raise ArgumentError unless kind == unit.kind
    quantity * unit.scale / scale
  end

  def smaller_units
    Unit.find(:all, { :conditions => ['family = ? AND kind = ? AND scale > ?', family, kind, scale], :order => 'scale ASC' })
  end

  def format(quantity)
    if quantity < 0
      raise ArgumentError, quantity
    end
    if quantity > 1 || quantity.almost == 1
      if (quantity.is_a?(Fixnum))
        sprintf('%d %s', quantity, abbr)
      elsif (i = quantity.to_i).almost == quantity
        sprintf('%d %s', i, abbr)
      else
        sprintf('%g %s', quantity, abbr)
      end
    else
      smaller_units.each_with_index do |smaller_unit, i|
        larger_quantity = convert_quantity_to(quantity, smaller_unit)
        if larger_quantity >= 1 || i == smaller_units.length - 1
          return smaller_unit.format(larger_quantity)
        end
      end
    end
  end
end
