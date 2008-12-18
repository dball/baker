Recipe.delete_all

ActiveRecord::Base.transaction do
  Recipe.create({ :name => 'poolish', :base_weight => '11.25 oz',
    :preparation => 'Stir until flour is fully hydrated, cover, then ferment for 3 to 4 hours. Retard overnight or up to three days in the refrigerator.',
    :source => 'The Bread Baker\'s Apprentice',
    :source_page => 106,
    :ingredient_attributes => { :new => [
      { :name => 'bread flour', :percent => 100 },
      { :name => 'water', :percent => 107 },
      { :name => 'yeast', :percent => 0.27 }
    ]}})
  
  Recipe.create({ :name => 'biga', :base_weight => '11.25 oz',
    :preparation => 'Combine the flour and yeast, then add the water, stirring until it forms a rough dough. Knead until pliable and tacky, 78-80°. Cover and ferment 3 hours or until doubled. Retard overnight or up to three days in the refrigerator.',
    :source => 'The Bread Baker\'s Apprentice',
    :source_page => 107,
    :ingredient_attributes => { :new => [
      { :name => 'bread flour', :percent => 100 },
      { :name => 'water', :percent => 66.7 },
      { :name => 'yeast', :percent => 0.49 }
    ]}})

  Recipe.create({ :name => 'pâte fermentée', :base_weight => '11.25 oz',
    :preparation => 'Combine the flour, salt, and yeast, then add the water, stirring until it forms a rough dough. Knead until pliable and tacky, 78-80°. Cover and ferment 1 hour or until 150% of its original volume. Retard overnight or up to three days in the refrigerator, or three months in the freezer.',
    :source => 'The Bread Baker\'s Apprentice',
    :source_page => 105,
    :ingredient_attributes => { :new => [
      { :name => 'bread flour', :percent => 100 },
      { :name => 'water', :percent => 65 },
      { :name => 'salt', :percent => 1.9 },
      { :name => 'yeast', :percent => 0.55 }
    ]}})

  Recipe.create({ :name => 'french bread', :base_weight => '10 oz',
    :preparation => 'Remove the pâte fermentée dough from the refrigerator, cut until a dozen pieces, and let sit covered for an hour. Mix the flour, salt, yeast, and dough pieces, then add the water, stirring until it forms a rough dough. Knead until pliable and tacky, 78-80°. Oil, cover, and let rise 2 hours or until doubled. Shape, proof, and bake at 450° for 20-30 minutes.',
    :source => 'The Bread Baker\'s Apprentice',
    :source_page => 170,
    :ingredient_attributes => { :new => [
      { :name => 'pâte fermentée', :subrecipe_id => Recipe.find_by_name!('pâte fermentée').id, :percent => 160 },
      { :name => 'all-purpose flour', :percent => 50 },
      { :name => 'bread flour', :percent => 50 },
      { :name => 'water', :percent => 65 },
      { :name => 'salt', :percent => 1.9 },
      { :name => 'yeast', :percent => 0.55 }
    ]}})
end
