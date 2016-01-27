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

  describe 'showing the edit button' do
    #if user_signed_in and current_user.has_role? :admin
    #
    #OR
    #
    #user_signed_in and current_user.can_manage_location? @location

    class Location
      attr_accessor :can_manage

      def initialize(can_manage)
        @can_manage = can_manage
      end
    end

    class CurrentUser
      attr_accessor :role

      def initialize(role)
        @role = role
      end

      def has_role?(role)
        true if role == @role
      end

      def can_manage_location?(location)
        true if location.can_manage
      end
    end

    before(:each) do
      @current_user = CurrentUser.new(:admin)
    end

    it 'should show the edit button if the user is signed in and has role of admin' do
      expect(show_edit_button?(true, @current_user)).to be_true
    end

    it 'should not show the edit button if the user is not signed in' do
      expect(show_edit_button?(false, @current_user)).to be_false
    end

    it 'should not show the edit button if the user is not an admin' do
      @current_user.role = :grunt
      expect(show_edit_button?(true, @current_user)).to be_false
    end

    it 'should not show the edit button if the user is not an admin and the user is not signed in' do
      expect(show_edit_button?(false, @current_user)).to be_false
    end

    it 'should show the edit button if the user is signed in and the user can manage the location' do
      location = Location.new(true)
      @current_user.role = :grunt
      expect(show_edit_button?(true, @current_user, location)).to be_true
    end

    it 'should not show the edit button if the user can not manage the location' do
      location = Location.new(false)
      @current_user.role = :grunt
      expect(show_edit_button?(true, @current_user, location)).to be_false
    end
  end

  describe 'showing the send message button' do
    #if user_signed_in?

  end

  describe 'showing the claim business button' do
    #if !@location.user_ids.present? and user_signed_in? and !@location.claim_pending
  end

  describe 'showing the release business button' do
    #if @location.users.present? and user_signed_in? and @location.user_can_manage? current_user
  end

  describe 'show claim pending' do
    #location.users.present? and user_signed_in? and @location.user_owns? current_userand !@location.user_can_manage? current_user
  end
end
