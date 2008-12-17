describe "almost" do
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
