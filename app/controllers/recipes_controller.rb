class RecipesController < ResourceController::Base
  show.before do
    @weight_units = Unit.find(:all, :conditions => { :kind => @recipe.weight_unit.kind })
    if params[:weight_unit]
      @recipe.weight_unit = Unit.find(params[:weight_unit])
    end
    @recipe.ingredients.each do |ingredient|
      ingredient.recipe = @recipe
    end
  end

  private

  def object
    @object ||= Recipe.find(:first, :conditions => {:id => params[:id]}, :include => :ingredients)
  end
end
