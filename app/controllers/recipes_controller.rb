class RecipesController < ResourceController::Base
  permit 'owner of :object', :only => [ :edit, :update, :destroy ]

  show.before do
    if params[:weight_unit_family]
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

  def object
    @object ||= Recipe.find(param, :include => :ingredients) unless param.nil?
    @object
  end
end
