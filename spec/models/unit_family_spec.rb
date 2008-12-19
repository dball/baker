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
  end
end
