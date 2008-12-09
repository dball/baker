require File.dirname(__FILE__) + '/../../spec_helper'

describe 'recipes/edit.html.erb' do
  before(:each) do
    assigns[:recipe] = @recipe = Recipe.generate
    render "/recipes/edit"
  end

  it "should have an edit name field" do
    response.should have_tag('input#recipe_name')
  end
end
