require 'spec_helper'

describe StaticPagesController do
  it "should return successfully when going to the about page" do
  	get :about
  	expect(response).to render_template("about")
  	expect(response.status).to eq(200)
  end

  it "should return successfully when going to the terms page" do
  	get :terms
 	expect(response).to render_template("terms")
  	expect(response.status).to eq(200)
  end

  it "should return successfully when going to the privacy page" do
  	get :privacy
 	expect(response).to render_template("privacy")
  	expect(response.status).to eq(200)
  end

  it "should return successfully when going to the contact page" do
  	get :contact
 	expect(response).to render_template("contact")
  	expect(response.status).to eq(200)
  end
end