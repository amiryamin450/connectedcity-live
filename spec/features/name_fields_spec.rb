require 'spec_helper'

describe "Name Fields on Sign Up", :type => :feature do
  it "Should find a first and last name field" do

    Capybara.current_driver = :selenium
    Capybara.run_server = false
    Capybara.app_host = 'http://localhost:3000'

    visit new_user_registration_path
    expect(page).to have_field("First name")
    expect(page).to have_field("Last name")
  end

  it "should allow a user to sign up with a postal code" do
    Capybara.current_driver = :selenium
    Capybara.run_server = false
    Capybara.app_host   = 'http://localhost:3000'

    visit new_user_registration_path
    fill_in 'First name', :with => 'Test'
    fill_in 'Last name', :with => 'Test'
    fill_in 'Email', :with => 'test@test.com'
    fill_in 'user_password', :with => 'Password'
    fill_in 'user_password_confirmation', :with => 'Password'

    click_button 'Sign up'
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please open the link to activate your account.'
  end
end