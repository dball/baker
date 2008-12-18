class Recipe < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :ingredients, :dependent => :destroy

  attr_accessor :scale

  def scale
    @scale ||= 1
  end

  def base_weight
    @base_weight ||= Unit(self[:base_weight])
  end

  def base_weight=(value)
    @base_weight = value.is_a?(Unit) ? value : Unit(value)
    self[:base_weight] = @base_weight.to_s
  end

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

  after_update do |recipe|
    recipe.ingredients.each { |ingredient| ingredient.save(false) }
  end

  def total_percent
    ingredients.inject(0) {|sum, ingredient| sum += ingredient.percent }
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
