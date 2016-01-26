require 'spec_helper'

describe LocationsHelper do
  describe 'showing save button' do
  	it 'should show the save button if user is signed in and location has vertical markets' do
  	  expect(show_save_button?(true, true)).to be_true
  	end

  	it 'should show the save button even though the user is not signed in but has vertical markets' do
	  expect(show_save_button?(false, true)).to be_true
  	end

  	it 'should not show the save button if there are no vertical markets regardless of whether the user is signed in' do
	  expect(show_save_button?(true, false)).to be_false
	  expect(show_save_button?(false, false)).to be_false
  	end
  end
end