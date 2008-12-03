module RecipesHelper
  def fields_for_ingredient(ingredient, &block)
    prefix = ingredient.new_record? ? 'new' : 'existing'
    fields_for("recipe[#{prefix}_ingredient_attributes][]", ingredient, &block)
  end
end

