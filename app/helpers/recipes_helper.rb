module RecipesHelper
  def fields_for_ingredient(ingredient, &block)
    suffix = ingredient.new_record? ? '[new]' : ''
    fields_for("recipe[ingredient_attributes]#{suffix}[]", ingredient, &block)
  end

  def format(ingredient)
    quantity = ingredient.weight
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

