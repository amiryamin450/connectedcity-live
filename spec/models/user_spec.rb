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

  it "should not be valid if no Postal Code is entered" do
    new_user = FactoryGirl.build(:user)
    expect(new_user).not_to be_valid
    expect(new_user.errors[:postal_code]).to include("can't be blank")
  end

  it "should not allow invalid Postal Codes" do
    new_user = FactoryGirl.build(:user, :postal_code => "Blah")
    expect(new_user).not_to be_valid
    expect(new_user.errors[:postal_code]).to include("Postal Code must be in format of A1A 1A1")
  end

  it "should be valid if proper Postal Code is used" do
    new_user = FactoryGirl.build(:user, :postal_code => "A1A 1A1")
    expect(new_user).to be_valid
  end

  it "should not allow any character other than a space" do
    new_user = FactoryGirl.build(:user, :postal_code => "A1A-1A1")
    expect(new_user).not_to be_valid
    expect(new_user.errors[:postal_code]).to include("Postal Code must be in format of A1A 1A1")
  end
end

