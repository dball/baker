class Recipe < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :base_weight
  # FIXME - validate Unitness of base_weight

  has_many :ingredients, :dependent => :destroy
  belongs_to :owner, :class_name => 'User'

  attr_accessor :scale, :weight_unit_family

  def accepts_role?(role, user)
    user == owner || user.has_role?(role)
  end

  def scale
    @scale ||= 1
  end

  WEIGHT_UNIT_FAMILIES = [
    UnitFamily.new('us', ['lb', 'oz'], :fraction),
    UnitFamily.new('metric', ['g'], :decimal)
  ]

  def weight_unit_family
    @weight_unit_family ||= base_weight_unit_family
  end

  def weight_unit_family=(name)
    family = WEIGHT_UNIT_FAMILIES.find {|family| family.name == name }
    raise ArgumentError, name if family.nil?
    @weight_unit_family = family
  end

  def base_weight
    unless @base_weight
      begin
        @base_weight = Unit(self[:base_weight])
      rescue ArgumentError
        @base_weight = nil
      end
    end
    @base_weight
  end

  def base_weight=(value)
    if value.is_a?(Unit)
      @base_weight = value
    else
      begin
        @base_weight = Unit(value)
      rescue ArgumentError
        @base_weight = nil
      end
    end
    self[:base_weight] = @base_weight.nil? ? nil : @base_weight.to_s
  end

  def base_weight_unit_family
    units = base_weight.units
    if family = WEIGHT_UNIT_FAMILIES.find { |family| family.include?(units) }
      family
    end
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

  def Recipe.filter_ingredient_attributes(attributes)
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
