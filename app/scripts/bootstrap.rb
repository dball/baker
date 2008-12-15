Recipe.delete_all
Unit.delete_all

ActiveRecord::Base.transaction do
  Unit.create({ :name => 'ounce', :abbr => 'oz', :kind => 'weight', :scale => 1 })
  Unit.create({ :name => 'pound', :abbr => 'lb', :kind => 'weight', :scale => 0.0625 })
  Unit.create({ :name => 'gram', :abbr => 'g', :kind => 'weight', :scale => 28.3495 })
  Unit.create({ :name => 'kilogram', :abbr => 'kg', :kind => 'weight', :scale => 0.0283495 })
  
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
    :preparation => 'Stir until flour is fully hydrated, cover, then ferment for 3 to 4 hours. Retard overnight or up to three days in the refrigerator.',
    :source => 'The Bread Baker\'s Apprentice',
    :source_page => 106,
    :ingredient_attributes => { :new => [
      { :name => 'bread flour', :percent => 100 },
      { :name => 'water', :percent => 107 },
      { :name => 'yeast', :percent => 0.27 }
    ]}})
  
  Recipe.create({ :name => 'biga', :default_unit_scale => 11.25,
    :preparation => 'Combine the flour and yeast, then add the water, stirring until it forms a rough dough. Knead until pliable and tacky, 78-80°. Cover and ferment 3 hours or until doubled. Retard overnight or up to three days in the refrigerator.',
    :source => 'The Bread Baker\'s Apprentice',
    :source_page => 107,
    :ingredient_attributes => { :new => [
      { :name => 'bread flour', :percent => 100 },
      { :name => 'water', :percent => 66.7 },
      { :name => 'yeast', :percent => 0.49 }
    ]}})

  Recipe.create({ :name => 'pâte fermentée', :default_unit_scale => 11.25,
    :preparation => 'Combine the flour, salt, and yeast, then add the water, stirring until it forms a rough dough. Knead until pliable and tacky, 78-80°. Cover and ferment 1 hour or until 150% of its original volume. Retard overnight or up to three days in the refrigerator, or three months in the freezer.',
    :source => 'The Bread Baker\'s Apprentice',
    :source_page => 105,
    :ingredient_attributes => { :new => [
      { :name => 'bread flour', :percent => 100 },
      { :name => 'water', :percent => 65 },
      { :name => 'salt', :percent => 1.9 },
      { :name => 'yeast', :percent => 0.55 }
    ]}})
end
