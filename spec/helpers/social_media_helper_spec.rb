require 'spec_helper'

describe SocialMediaHelper do
  describe "Displaying Social Media Icons" do
    it "should output the html with the Business URL" do
        expect(render_social_media_buttons({ url: "http://localhost:3000/business/don-s-computers", title: "Don's Computers", content: "This is a test" })).to include("http://localhost:3000/business/don-s-computers")
    end
  end
end
