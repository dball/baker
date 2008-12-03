class Recipe < ActiveRecord::Base
  has_many :ingredients

  validates_presence_of :name
  validates_uniqueness_of :name

  def new_ingredient_attributes=(ingredient_attributes)
    ingredient_attributes.each do |attributes|
      ingredients.build(attributes)
    end
  end

  def existing_ingredient_attributes=(ingredient_attributes)
    ingredients.reject(&:new_record?).each do |ingredient|
      if attributes = ingredient_attributes[ingredient.id.to_s]
        ingredient.attributes = attributes
      else
        basket.ingredients.delete(ingredient)
      end
    end
  end

  after_update do
    ingredients.each { |ingredient| ingredient.save(false) }
  end
end
