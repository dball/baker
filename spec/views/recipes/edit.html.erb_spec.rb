require File.dirname(__FILE__) + '/../../spec_helper'

describe 'recipes/edit.html.erb' do
  before(:each) do
    assigns[:recipe] = Recipe.generate
    render "/recipes/edit"
  end

  it "should have an edit form" do
    response.should have_tag("form[method='post']") do
      response.should have_tag("label[for='recipe_name']")
      response.should have_tag("input#recipe_name[name='recipe[name]']")
    end
  end
end
