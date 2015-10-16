require 'spec_helper'

describe User do
  describe "Creating a User" do
    it "should not be valid if no Postal Code is entered" do
      new_user = FactoryGirl.build(:user)
      expect(new_user).not_to be_valid
      expect(new_user.errors[:postal_code]).to include("can't be blank")
    end

    it "should not allow invalid Postal Codes" do
      new_user = FactoryGirl.build(:user, :postal_code => "Blah")
      expect(new_user).not_to be_valid
      expect(new_user.errors[:postal_code]).to include("Postal Code must be in format of A1A-1A1 or a1a-1a1")
    end

    it "should be valid if proper Postal Code is used" do
      new_user = FactoryGirl.build(:user, :postal_code => "A1A-1A1")
      expect(new_user).to be_valid
    end

    it "should allow a space instead of a hyphen for the postal code" do
      new_user = FactoryGirl.build(:user, :postal_code => "A1A 1A1")
      expect(new_user).to be_valid
    end

    it "should not allow any character other than a space or a hyphen" do
      new_user = FactoryGirl.build(:user, :postal_code => "A1A%1A1")
      expect(new_user).not_to be_valid
      expect(new_user.errors[:postal_code]).to include("Postal Code must be in format of A1A-1A1 or a1a-1a1")
    end
  end
end
