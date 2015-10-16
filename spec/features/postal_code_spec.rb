require 'spec_helper'

describe "Postal Code Tests", :type => :feature do
  it "should have the postal code field" do

    Capybara.current_driver = :selenium
    Capybara.run_server = false
    Capybara.app_host   = 'http://localhost:3000'

    visit new_user_registration_path
    expect(page).to have_field("Postal code")
  end

  it "should allow a user to sign up with a postal code" do
    Capybara.current_driver = :selenium
    Capybara.run_server = false
    Capybara.app_host   = 'http://localhost:3000'

    visit new_user_registration_path
    fill_in 'Name', :with => 'Test Test'
    fill_in 'Email', :with => 'test@test.com'
    fill_in 'Postal code', :with => 'A1A 1A1'
    fill_in 'user_password', :with => 'Password'
    fill_in 'user_password_confirmation', :with => 'Password'

    click_button 'Sign up'

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please open the link to activate your account.'
  end
end
