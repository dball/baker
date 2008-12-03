class Ingredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :subrecipe, :class_name => 'Recipe'

  validates_presence_of :recipe
end
