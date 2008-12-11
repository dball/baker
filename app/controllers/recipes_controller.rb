class RecipesController < ResourceController::Base
  show.before do
    @weight_units = Unit.find(:all, :conditions => { :kind => @recipe.weight_unit.kind })
    if params[:weight_unit]
      @recipe.weight_unit = Unit.find(params[:weight_unit])
    end
    # FIXME - One would think eagerly loading children would set the parent
    # at that time. One would be incorrect.
    @recipe.ingredients.each do |ingredient|
      ingredient.recipe = @recipe
    end
  end

  private

  def object
    @object ||= Recipe.find(param, :include => :ingredients) unless param.nil?
    @object
  end
end
