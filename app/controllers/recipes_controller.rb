class RecipesController < ResourceController::Base
  edit.before do
    @recipe.ingredients.build
  end
end
