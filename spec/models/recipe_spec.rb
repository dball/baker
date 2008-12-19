require File.dirname(__FILE__) + '/../spec_helper'

describe Recipe do
  describe "all recipes", :shared => true do
    it "must have a name" do
      @recipe.name.class.should == String
    end

    it "must accept a name" do
      x = @recipe.name = 'Foo'
      @recipe.name.should == x
    end

    it "must have a base weight" do
      @recipe.base_weight.class.should == Unit
    end

    it "must accept a base weight" do
      x = @recipe.base_weight = '100 g'
      @recipe.base_weight.should == Unit(x)
    end

    it "must have a base weight unit family" do
      @recipe.base_weight_unit_family.class.should == String
    end

    it "must have a weight unit family" do
      @recipe.weight_unit_family.class.should == String
    end

    it "must accept a weight unit family" do
      x = @recipe.weight_unit_family = Recipe.weight_unit_families.last
      @recipe.weight_unit_family.should == x
    end

    it "must have ingredients" do
      @recipe.ingredients.map {|i| i.class }.all? {|c| c == Ingredient }.should be_true
    end

    it "should add new ingredients" do
      new_attributes = (1..3).to_a.map do
        Ingredient.spawn.attributes.reject {|k, v| k == 'recipe_id' }
      end
      old_attributes = @recipe.ingredients.map {|i| i.attributes }
      values = {}
      @recipe.ingredients.each do |ingredient|
        next if ingredient.new_record?
        values[ingredient.id.to_s] = ingredient.attributes
      end
      values[:new] = new_attributes
      @recipe.ingredient_attributes = values
      @recipe.ingredients.map {|i| i.attributes }.should ==
        old_attributes + 
        new_attributes.map {|attr| attr.merge({ 'recipe_id' => @recipe.id }) }
    end

    it "should have a total_percent of the sum of its ingredients" do
      total_percent = 0
      @recipe.ingredients.each do |ingredient|
        total_percent += ingredient.percent
      end
      @recipe.total_percent.should == total_percent
    end
  end

  describe "a valid saved recipe", :shared => true do
    it "must have no errors" do
      @recipe.errors.should be_empty
    end

    it "must have a unique name" do
      Recipe.generate(:name => @recipe.name).errors.on(:name).should == 
        'has already been taken'
    end
  end

  describe "a valid saved recipe with ingredients", :shared => true do
    it "should edit existing saved ingredients" do
      values = {}
      old_attributes = @recipe.ingredients.map {|i| i.attributes }
      @recipe.ingredients.each do |ingredient|
        next if ingredient.new_record?
        values[ingredient.id.to_s] = ingredient.attributes.merge({ 'percent' => 0 })
      end
      @recipe.ingredient_attributes = values
      @recipe.ingredients.reject {|i| i.new_record?}.map {|i| i.attributes }.should ==
        old_attributes.map {|attr| attr.merge({ 'percent' => 0 }) }
    end

    it "should delete an existing saved ingredient" do
      new_ingredient_ids = @recipe.ingredient_ids[1..-1]
      values = {}
      new_ingredient_ids.each do |id|
        attributes = Ingredient.find(id).attributes
        attributes.delete('recipe_id')
        values[id.to_s] = attributes
      end
      @recipe.ingredient_attributes = values
      @recipe.ingredient_ids.should == new_ingredient_ids
    end
  end

  describe "an empty unsaved recipe" do
    before(:each) do
      @recipe = Recipe.spawn
    end

    it_should_behave_like "all recipes"
  end

  describe "an empty recipe" do
    before(:each) do
      @recipe = Recipe.generate
    end
    
    it_should_behave_like "all recipes"
    it_should_behave_like "a valid saved recipe"
  end

  describe "an unsaved recipe with ingredients" do
    before(:each) do
      @recipe = Recipe.spawn
      3.times { @recipe.ingredients << Ingredient.spawn }
    end

    it_should_behave_like "all recipes"
  end

  describe "a recipe with ingredients" do
    before(:each) do
      @recipe = Recipe.generate
      3.times do
        @recipe.ingredients.create(Ingredient.spawn.attributes.reject {|k, v| k == 'recipe_id' })
      end
    end

    it_should_behave_like "all recipes"
    it_should_behave_like "a valid saved recipe"
    it_should_behave_like "a valid saved recipe with ingredients"
  end

  describe "recipe class methods" do
    it "should filter ingredient attributes" do
      recipe = Recipe.generate
      attributes = { :percent => 50, :name => recipe.name}
      Recipe.filter_ingredient_attributes(attributes).should == 
        { :percent => 50, :subrecipe_id => recipe.id }
    end
  end
end
