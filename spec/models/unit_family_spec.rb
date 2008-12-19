require File.dirname(__FILE__) + '/../spec_helper'

describe UnitFamily do
  describe "all objects", :shared => true do
    it "should have a name" do
      @family.name.class.should == String
    end

    it "should have a list of units" do
      @family.units.all? {|unit| unit.class.should == Unit }
    end

    it "should have an output format" do
      UnitFamily::OUTPUT_FORMATS.include?(@family.output_format).should be_true
    end
  end

  describe "english distance family" do
    before(:each) do
      @family = UnitFamily.new('english', ['foot', 'inch'], :fraction)
    end

    it_should_behave_like "all objects"

    it "should format 2 feet" do
      @family.format(Unit('2 ft')).should == '2 ft'
    end

    it "should format 2.5 feet" do
      @family.format(Unit('2.5 ft')).should == '2 1/2 ft'
    end
  end

  describe "metric distance family" do
    before(:each) do
      @family = UnitFamily.new('metric', ['meter', 'cm', 'mm'], :decimal)
    end

    it_should_behave_like "all objects"

    it "should format 2 meters" do
      @family.format(Unit('2 m')).should == '2 m'
    end

    it "should format 2.5 meters" do
      @family.format(Unit('2.5 m')).should == '2.5 m'
    end
  end
end
