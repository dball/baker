class Recipe
  generator_for :name, :start => 'bread'
  generator_for :preparation, 'Bake it.'
  generator_for :source, 'Joy of Cooking'
  generator_for :source_page, :start => 23
  generator_for :base_weight, '10 oz'
end
