class Ingredient < ActiveRecord::Base
  belongs_to :unit
  belongs_to :recipe

  validates_presence_of :unit
  validates_presence_of :recipe
end
