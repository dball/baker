class Recipe < ActiveRecord::Base
  has_many :ingredients, :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name

  def ingredient_attributes=(values)
    ingredients.reject(&:new_record?).each do |ingredient|
      if attributes = values[ingredient.id.to_s]
        ingredient.attributes = attributes
      else
        ingredients.delete(ingredient)
      end
    end
    values[:new].each do |attributes|
      next if attributes.values.all? {|value| value.blank? }
      ingredient = ingredients.build(attributes)
      ingredient.recipe = self
    end if values[:new]
  end

  after_update do |recipe|
    recipe.ingredients.each { |ingredient| ingredient.save(false) }
  end
end
