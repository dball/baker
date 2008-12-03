require File.dirname(__FILE__) + '/../spec_helper'

describe Recipe do
  describe "all recipes", :shared => true do
    it "must have a name" do
      @recipe.name.class.should == String
    end

    it "must have ingredients" do
      @recipe.ingredients.map {|i| i.class }.all? {|c| c == Ingredient }.should be_true
    end

    it "should build new ingredients via new_ingredient_attributes" do
      attributes = (1..3).to_a.map do
        Ingredient.spawn.attributes.reject {|k, v| k == 'recipe_id' }
      end
      old_ingredient_attributes = @recipe.ingredients.map {|i| i.attributes }
      @recipe.new_ingredient_attributes = attributes
      @recipe.ingredients.map {|i| i.attributes }.should ==
        old_ingredient_attributes + 
        attributes.map {|attr| attr.merge({ 'recipe_id' => @recipe.id }) }
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
      3.times { @recipe.ingredients << Ingredient.generate }
    end

    it_should_behave_like "all recipes"
    it_should_behave_like "a valid saved recipe"
  end
end
