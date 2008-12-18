require File.dirname(__FILE__) + '/../spec_helper'
require 'mathn'

describe Almost do
  describe "equals" do
    it "2 and 1.999 are almost equal" do
      should_be_almost_equal(2, 1.999)
    end
  
    it "999 and 1000 are almost equal" do
      should_be_almost_equal(999, 1000)
    end
  
    it "1/3 and 0.333 are almost equal" do
      should_be_almost_equal(Rational(1, 3), 0.333)
    end
  
    it "0.01 and 0.00999 are almost equal" do
      should_be_almost_equal(0.01, 0.00999)
    end
  
    it "0 and 1 are not almost equal" do
      should_not_almost_equal(0, 1)
    end
  
    it "2 and 1.996 are not almost equal" do
      should_not_almost_equal(2, 1.996)
    end
  
    it "9 and 10 are almost equal with sufficiently large epsilon" do
      (9.almost(0.1) == 10).should be_true
    end
  
    it "9 and 10 are not almost equal with insufficiently large epsilon" do
      (9.almost(0.01) == 10).should be_false
    end
  
    def should_be_almost_equal(x, y)
      (x.almost == y).should be_true
      (y.almost == x).should be_true
    end
  
    def should_not_almost_equal(x, y)
      (x.almost == y).should be_false
      (y.almost == x).should be_false
    end
  end

  describe "fractions" do
    it "0.5 is nearly 1/2 by 1/2" do
      0.5.nearest(1/2).should == 1/2
    end

    it "0.25 is nearly 1/4 by 1/4" do
      0.25.nearest(1/4).should == 1/4
    end

    it "0.5 is nearly 1/2 by 1/4" do
      0.5.nearest(1/4).should == 1/2
    end

    it "0.24999 is nearly 0 by 1/2" do
      0.24999.nearest(1/2).should == 0
    end

    it "0.25 is nearly 0 by 1/2" do
      0.25.nearest(1/2).should == 1/2 
    end
  end

  describe "rational to_s" do
    it "1/2 is 1/2" do
      (1/2).to_s.should == "1/2"
    end

    it "1/2 is 1/2 split" do
      (1/2).to_s(:split).should == "1/2"
    end

    it "3/2 is 3/2" do
      (3/2).to_s.should == "3/2"
    end

    it "3/2 is 1 1/2 split" do
      (3/2).to_s(:split).should == "1 1/2"
    end

    it "45/4 is 11 1/4 split" do
      (45/4).to_s(:split).should == "11 1/4"
    end
  end
end
