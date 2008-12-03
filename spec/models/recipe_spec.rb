require File.dirname(__FILE__) + '/../spec_helper'

describe Recipe do
  describe "all recipes", :shared => true do
    it "must have a name" do
      @recipe.name.class.should == String
    end

    it "must have ingredients" do
      @recipe.ingredients.map {|i| i.class }.all? {|c| c == Ingredient }.should be_true
    end
  end

  describe "an empty recipe" do
    before(:each) do
      @recipe = Recipe.generate
    end
    
    it_should_behave_like "all recipes"
  end

  describe "with two ingredients" do
    before(:each) do
      @recipe = Recipe.generate
      2.times { @recipe.ingredients << Ingredient.generate }
    end

    it_should_behave_like "all recipes"
  end
end
