class Ingredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :subrecipe, :class_name => 'Recipe'

  validates_presence_of :recipe

  def weight
    recipe.base_weight * (percent / 100)
  end
end
