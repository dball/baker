require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  before(:each) do
    @user = User.generate
  end

  it "must have a login" do
    @user.login.class.should == String
  end

  it "must have a unique login" do
    User.generate(:login => @user.login).errors.on(:login).should ==
      'has already been taken'
  end
end
