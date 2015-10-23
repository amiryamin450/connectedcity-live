require 'spec_helper'

describe "User" do
  it "should not be valid without a first name" do
    new_user = FactoryGirl.build(:user, :first_name => nil)

    expect(new_user).not_to be_valid
    expect(new_user.errors[:first_name]).to include("can't be blank")
  end

  it "should not be valid without a last name" do
    new_user = FactoryGirl.build(:user, :last_name => nil)

    expect(new_user).not_to be_valid
    expect(new_user.errors[:last_name]).to include("can't be blank")
  end  
end