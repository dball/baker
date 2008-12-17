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

    it "must be able to format a quantity" do
      @unit.format(1).class.should == String
    end
  end

  describe "a unit" do
    before(:each) do
      @unit = Unit.generate
    end
    
    it_should_behave_like "all units"
  end

  describe "formatting quantities" do
    before(:all) do
      @inch = Unit.generate({ :name => 'inch', :abbr => 'in', :family => 'us', :kind => 'distance', :scale => 12 })
      @foot = Unit.generate({ :name => 'foot', :abbr => 'ft', :family => 'us', :kind => 'distance', :scale => 1 })
      @yard = Unit.generate({ :name => 'yard', :abbr => 'yd', :family => 'us', :kind => 'distance', :scale => 0.333 })
    end

    it "1 foot should format as 1 ft" do
      @foot.format(1).should == '1 ft'
    end

    it "2 feet should format as 2 ft" do
      @foot.format(2).should == '2 ft'
    end

    it "0.5 feet should format as 6 in" do
      @foot.format(0.5).should == '6 in'
    end

    it "0.333 yards should format as 1 ft" do
      @yard.format(0.333).should == '1 ft'
    end
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
