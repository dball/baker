require File.dirname(__FILE__) + '/../spec_helper'

describe Ingredient do
  describe "all ingredients", :shared => true do
    it "must have a name" do
      @ingredient.name.class.should == String
    end

    it "must have a recipe" do
      @ingredient.recipe.class.should == Recipe
    end

    it "must have a percent" do
      @ingredient.percent.class.should == BigDecimal
    end

    it "must have a weight" do
      @ingredient.weight.class.should == Unit
    end
  end

  describe "a simple ingredient" do
    before(:each) do
      @ingredient = Ingredient.generate
    end

    it_should_behave_like "all ingredients"

    it "must not have a subrecipe" do
      @ingredient.subrecipe.should be_nil
    end
  end

  describe "an ingredient of a recipe" do
    before(:each) do
      @subrecipe = Recipe.generate
      @ingredient = Ingredient.generate( :subrecipe => @subrecipe )
    end

    it_should_behave_like "all ingredients"

    it "must have a subrecipe" do
      @ingredient.subrecipe.should == @subrecipe
    end
  end
end
