class Unit
  generator_for :name, :start => 'teaspoon'
  generator_for :abbr, :start => 'tsp'
  generator_for :scale, 1
  KINDS = ['volume', 'weight']
  generator_for :kind, :start => 'volume' do |prev|
    KINDS.reject {|k| k == prev}.first
  end
  FAMILIES = ['us', 'metric']
  generator_for :family, :start => 'us' do |prev|
    FAMILIES.reject {|k| k == prev}.first
  end
end
