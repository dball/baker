class RecipesController < ResourceController::Base
  show.before do
    if params[:weight_unit_family] && Recipe.weight_unit_families.include?(params[:weight_unit_family])
      @recipe.weight_unit_family = params[:weight_unit_family]
    end
    if params[:scale]
      @recipe.scale = params[:scale].to_f
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
