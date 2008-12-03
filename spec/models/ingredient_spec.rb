require File.dirname(__FILE__) + '/../spec_helper'

describe Ingredient do
  describe "all ingredients", :shared => true do
    it "must have a name" do
      @ingredient.name.class.should == String
    end

    it "must have a unit" do
      @ingredient.unit.class.should == Unit
    end

    it "must have a recipe" do
      @ingredient.recipe.class.should == Recipe
    end
  end

  describe "an empty ingredient" do
    before(:each) do
      @ingredient = Ingredient.generate
    end

    it_should_behave_like "all ingredients"
  end
end
