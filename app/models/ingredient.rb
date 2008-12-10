class Ingredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :subrecipe, :class_name => 'Recipe'

  validates_presence_of :recipe

  def weight
    percent * recipe.default_unit_scale * recipe.weight_unit.scale / 100
  end
end
