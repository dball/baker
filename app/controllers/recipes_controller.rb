class RecipesController < ResourceController::Base
  show.before do
    @unit = Unit.find_by_name('ounce')
  end
end
