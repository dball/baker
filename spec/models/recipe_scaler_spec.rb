require File.dirname(__FILE__) + '/../spec_helper'

describe RecipeScaler do
  before(:each) do
    @scaler = RecipeScaler.new
  end

  it "should have a recipe" do
    @scaler.should respond_to(:recipe)
    @scaler.should respond_to(:recipe=)
  end

end
