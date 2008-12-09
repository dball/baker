module RecipesHelper
  def fields_for_ingredient(ingredient, &block)
    suffix = ingredient.new_record? ? '[new]' : ''
    fields_for("recipe[ingredient_attributes]#{suffix}[]", ingredient, &block)
  end
end

