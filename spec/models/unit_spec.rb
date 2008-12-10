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

    it "must have a scale" do
      @unit.scale.class.should == BigDecimal
    end

    it "must have a positive scale" do
      @unit.scale.should > 0
    end
  end

  describe "a unit" do
    before(:each) do
      @unit = Unit.generate
    end
    
    it_should_behave_like "all units"
  end

  describe "converting between units" do
    before(:each) do
      @unit = Unit.generate
    end

    it "should convert to a unit of the same kind" do
      unit = Unit.generate({ :kind => @unit.kind, :scale => 2 })
      unit.convert_quantity_to(10, @unit).should == 5
    end

    it "should not convert to a unit of another kind" do
      unit = Unit.generate({ :kind => 'foo', :scale => 2 })
      lambda { unit.convert_quantity_to(10, @unit) }.should raise_error(ArgumentError)
    end
  end
end
