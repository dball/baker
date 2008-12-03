class Unit
  generator_for :name, :start => 'teaspoon'
  generator_for :abbr, :start => 'tsp'
  KINDS = ['volume', 'weight']
  generator_for :kind, :start => 'volume' do |prev|
    KINDS.reject {|k| k == prev}.first
  end
end
