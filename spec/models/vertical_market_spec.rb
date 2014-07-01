#spec/models/vertical_market.rb
require 'spec_helper'

describe VerticalMarket do
  
  it "has a valid factory" do
    FactoryGirl.create(:vertical_market).should be_valid
  end

  it "is invalid without a name" do
    FactoryGirl.build(:vertical_market, name: nil).should_not be_valid
  end

end