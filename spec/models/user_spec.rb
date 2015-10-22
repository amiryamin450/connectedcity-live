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

  it "should create a full name from the first and last name" do
    new_user = FactoryGirl.build(:user)
    new_user[:first_name] = "Test"
    new_user[:last_name] = "User"

    expect(User.fullname(new_user[:first_name], new_user[:last_name])).to eq("Test User")
  end

  it "should save a user with a full name from the first and last names" do
    new_user = FactoryGirl.build(:user, { first_name: "John", last_name: "Smith" })
    new_user.save!

    expect(new_user[:name]).to eq("John Smith")
  end
end