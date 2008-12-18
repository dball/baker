class Ingredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :subrecipe, :class_name => 'Recipe'

  validates_presence_of :recipe

  def weight
    Weight.new(self)
  end

  class Weight
    def initialize(ingredient)
      @ingredient = ingredient
    end

    def value
      @value ||= @ingredient.recipe.base_weight * @ingredient.recipe.scale * (@ingredient.percent / 100)
    end

    def to_s
      scalar = value.scalar.nearest(1/8)
      if scalar == 0
        value.to_s
      else
        scalar = (scalar.is_a?(Rational) ? scalar.to_s(:split) : scalar.to_s)
        scalar + ' ' + value.units
      end
    end
  end
end
