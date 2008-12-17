require File.dirname(__FILE__) + '/../spec_helper'

describe RecipeScaler do
  describe 'the object' do
    before(:each) do
      @scaler = RecipeScaler.new
    end
  
    it "should have a recipe" do
      @scaler.should respond_to(:recipe)
      @scaler.should respond_to(:recipe=)
    end
  
    it "should have a unit family" do
      @scaler.should respond_to(:unit_family)
      @scaler.should respond_to(:unit_family=)
    end
  
    it "should have a scale" do
      @scaler.should respond_to(:scale)
      @scaler.should respond_to(:scale=)
    end

    it "should have ingredients" do
      @scaler.should respond_to(:ingredients)
    end
  end

  describe "a recipe with one ounce of water" do
    before(:each) do
      @scaler = RecipeScaler.new
      @recipe = Recipe.new({ :default_unit_scale => 1 })
      @recipe.ingredients.build({ :name => 'water', :percent => 100 })
      @scaler.recipe = @recipe
      @scaler.unit_family = 'us'
      @scaler.scale = 1
    end

    it "should scale the ingredients" do
      pending "implementing the ingredients method"
      @scaler.ingredients.should == [{ :name => 'water', :percent => 100, :value => 1, :unit => Unit.find_by_name('ounce') }]
    end
  end
end
