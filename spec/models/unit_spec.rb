require File.dirname(__FILE__) + '/../spec_helper'

describe Unit do
  describe "all units", :shared => true do
    it "must have a name" do
      @unit.name.class.should == String
    end

    it "must have an abbreviation" do
      @unit.abbr.class.should == String
    end

    it "must have a kind" do
      @unit.kind.class.should == String
    end
  end

  describe "a unit" do
    before(:each) do
      @unit = Unit.generate
    end
    
    it_should_behave_like "all units"
  end
end
