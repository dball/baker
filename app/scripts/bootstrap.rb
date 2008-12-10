ActiveRecord::Base.transaction do
  Unit.create({ :name => 'ounce', :abbr => 'oz', :kind => 'weight', :scale => 1 })
  Unit.create({ :name => 'pound', :abbr => 'lb', :kind => 'weight', :scale => 0.0625 })
  Unit.create({ :name => 'gram', :abbr => 'g', :kind => 'weight', :scale => 28.3495 })
  Unit.create({ :name => 'kilogram', :abbr => 'kg', :kind => 'weight', :scale => 2834.95 })
  
  Unit.create({ :name => 'cup', :abbr => 'cup', :kind => 'volume', :scale => 1 })
  Unit.create({ :name => 'fluid ounce', :abbr => 'fl oz', :kind => 'volume', :scale => 8 })
  Unit.create({ :name => 'pint', :abbr => 'pt', :kind => 'volume', :scale => 0.5 })
  Unit.create({ :name => 'quart', :abbr => 'qt', :kind => 'volume', :scale => 0.25 })
  Unit.create({ :name => 'gallon', :abbr => 'gallon', :kind => 'volume', :scale => 0.0625 })
  Unit.create({ :name => 'tablespoon', :abbr => 'tbsp', :kind => 'volume', :scale => 16 })
  Unit.create({ :name => 'teaspoon', :abbr => 'tsp', :kind => 'volume', :scale => 48 })
  Unit.create({ :name => 'pinch', :abbr => 'pinch', :kind => 'volume', :scale => 384 })
  Unit.create({ :name => 'dash', :abbr => 'dash', :kind => 'volume', :scale => 768 })
  
  Recipe.create({ :name => 'poolish', :default_unit_scale => 11.25,
    :ingredient_attributes => { :new => [
      { :name => 'bread flour', :percent => 100 },
      { :name => 'water', :percent => 107 },
      { :name => 'yeast', :percent => 0.27 }
    ]}})
  
  Recipe.create({ :name => 'biga', :default_unit_scale => 11.25,
    :ingredient_attributes => { :new => [
      { :name => 'bread flour', :percent => 100 },
      { :name => 'water', :percent => 66.7 },
      { :name => 'yeast', :percent => 0.49 }
    ]}})
end
