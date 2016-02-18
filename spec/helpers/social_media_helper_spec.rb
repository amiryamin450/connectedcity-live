require 'spec_helper'

describe SocialMediaHelper do
  describe "Displaying Social Media Icons" do
    it "should return Business url for Status Update" do
      expect(get_social_url(:status_update)).to eql("http://localhost:3000/business/don-s-computers")
    end


  end
end
