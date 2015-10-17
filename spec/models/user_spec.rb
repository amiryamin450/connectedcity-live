require 'spec_helper'

describe "User" do
  it "should create a full name from the first and last name" do
    new_user = FactoryGirl.build(:user)
    new_user[:first_name] = "Test"
    new_user[:last_name] = "User"

    expect(User.fullname(new_user[:first_name], new_user[:last_name])).to eq("Test User")
  end

  it "should save a user with a full name from the first and last names" do
    new_user = FactoryGirl.build(:user)
    new_user[:first_name] = "John"
    new_user[:last_name] = "Smith"
    new_user.save!

    expect(new_user[:name]).to eq("John Smith")
  end
end