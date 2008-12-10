class Recipe < ActiveRecord::Base
  has_many :ingredients, :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name

  def ingredient_attributes=(values)
    ingredients.reject(&:new_record?).each do |ingredient|
      if attributes = values[ingredient.id.to_s]
        ingredient.attributes = Recipe.filter_ingredient_attributes(attributes)
      else
        ingredients.delete(ingredient)
      end
    end
    values[:new].each do |attributes|
      next if attributes.values.all? {|value| value.blank? }
      ingredient = ingredients.build(Recipe.filter_ingredient_attributes(attributes))
      ingredient.recipe = self
    end if values[:new]
  end

  def total_percent
    ingredients.inject(0) {|sum, ingredient| sum += ingredient.percent }
  end

  after_update do |recipe|
    recipe.ingredients.each { |ingredient| ingredient.save(false) }
  end

  def self.filter_ingredient_attributes(attributes)
    if (name = attributes[:name]) && recipe = Recipe.find_by_name(name)
      new_attributes = attributes.dup
      new_attributes.delete(:name)
      new_attributes[:subrecipe_id] = recipe.id
      new_attributes
    else
      attributes
    end
  end
end
