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

  it "should set the name to nil if no name is passed" do
    new_user = User.new
    new_user.first_name = "John"
    new_user.last_name = "Smith"

    expect(new_user.name).to eq("John Smith")

    new_user.name = nil

    expect(new_user.first_name).to eq(nil)
  end
end

