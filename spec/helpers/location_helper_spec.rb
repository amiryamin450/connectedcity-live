require 'spec_helper'

describe LocationsHelper do

  class Location
    #Too many arguments, come back to this later...
    attr_accessor :can_manage, :claim_pending, :user_ids, :users, :vertical_markets, :id

    def initialize(can_manage, claim_pending = nil, user_ids = nil, users = nil, vertical_markets = nil, id = nil)
      @can_manage = can_manage
      @claim_pending = claim_pending || false
      @user_ids = user_ids
      @users = users
      @vertical_markets = vertical_markets
      @id = id
    end

    def remove_user_ids
      remove_instance_variable(:@user_ids)
    end

    def user_can_manage?(user_id)
      true if @users.include?(user_id)
    end

    def user_owns?(user_id)
      self.user_can_manage?(user_id)
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

  class VerticalMarket
    attr_accessor :slug

    def initialize(slug)
      @slug = slug
    end
  end

  describe 'The Save Button' do
  	it 'should display if user is signed in and location has vertical markets' do
  	  expect(show_save_button?(true, true)).to be_true
  	end

  	it 'should display even though the user is not signed in but has vertical markets' do
	  expect(show_save_button?(false, true)).to be_true
  	end

  	it 'should not display if there are no vertical markets' do
	  expect(show_save_button?(true, false)).to be_false
	  expect(show_save_button?(false, false)).to be_false
  	end
  end

  describe 'The Edit Button' do

    before(:each) do
      @current_user = CurrentUser.new(:admin)
    end

    it 'should display if the user is signed in and has role of admin' do
      expect(show_edit_button?(true, @current_user)).to be_true
    end

    it 'should not display if the user is not signed in' do
      expect(show_edit_button?(false, @current_user)).to be_false
    end

    it 'should not display if the user is not an admin' do
      @current_user.role = :grunt
      expect(show_edit_button?(true, @current_user)).to be_false
    end

    it 'should not display if the user is not an admin and the user is not signed in' do
      expect(show_edit_button?(false, @current_user)).to be_false
    end

    it 'should display if the user is signed in and the user can manage the location' do
      location = Location.new(true)
      @current_user.role = :grunt
      expect(show_edit_button?(true, @current_user, location)).to be_true
    end

    it 'should not display if the user can not manage the location' do
      location = Location.new(false)
      @current_user.role = :grunt
      expect(show_edit_button?(true, @current_user, location)).to be_false
    end
  end

  describe 'The Send Message Button' do
    it 'should display if the user is signed in' do
      expect(show_message_button?(true)).to be_true
    end

    it 'should not display if the user is not signed in' do
      expect(show_message_button?(false)).to be_false
    end
  end

  describe 'The Claim Business Button' do
    
    before(:each) do
      @location = Location.new(true)
      @user_signed_in = true
    end

    it 'should display if the user ids are not part of the location, the user is signed in and the claim is not pending' do
      expect(show_claim_button?(@user_signed_in, @location)).to be_true
    end

    it 'should not display if the user is not signed in' do
      @user_signed_in = false
      expect(show_claim_button?(@user_signed_in, @location)).to be_false
    end

    it 'should not display if user ids are present in location' do
      @location.user_ids = "This is a test"
      expect(show_claim_button?(@user_signed_in, @location)).to be_false
    end

    it 'should have claim pending as false' do
      expect(@location.claim_pending).to be_false
    end

    it 'should remove user_ids' do
      @location.remove_user_ids
      expect(@location.user_ids.present?).to be_false
    end
    
    it 'should not display if there is a claim pending' do
      @location.claim_pending = true
      expect(show_claim_button?(@user_signed_in, @location)).to be_false
    end

    it 'should not display if there are user ids present in the location and if there is a claim pending' do
      @location.user_ids = "test"
      @location.claim_pending = true
      expect(show_claim_button?(@user_signed_in, @location)).to be_false
    end
  end

  describe 'The Release Business Button' do

    before(:each) do
      @location = Location.new(true)
      @user_signed_in = true
      @current_user = 1
    end

    it 'should display if the location has users present and the user is signed in and the current user can manage the location' do
      @location.users = [@current_user]
      expect(show_release_business_button?(@user_signed_in, @current_user, @location)).to be_true
    end

    it 'should not display if user is not signed in' do
      @user_signed_in = false
      @location.users = [@current_user]
      expect(show_release_business_button?(@user_signed_in, @current_user, @location)).to be_false
    end

    it 'should not display if users are not present' do
      expect(show_release_business_button?(@user_signed_in, @current_user, @location)).to be_false
    end

    it 'should not display if the user is not able to manage the location' do
      @location.users = [@current_user]
      @current_user = 2
      expect(show_release_business_button?(@user_signed_in, @current_user, @location)).to be_false
    end
  end

  describe 'Show Claim Pending' do
    
    before(:each) do
      @location = Location.new(true)
      @user_signed_in = true
      @current_user = 1
    end
  
    it 'should display if location has users and user is signed in and user owns the location and user can manage the location' do
      @location.users = [@current_user]
      expect(show_claim_pending?(@user_signed_in, @current_user, @location)).to be_true
    end

    it 'should not display if the user is not signed in' do
      @location.users = [@current_user]
      @user_signed_in = false
      expect(show_claim_pending?(@user_signed_in, @current_user, @location)).to be_false
    end
    
    it 'should not display if the location has no users' do
      expect(show_claim_pending?(@user_signed_in, @current_user, @location)).to be_false
    end

    it 'should not display if the user does not own the location' do
      @location.users = [@current_user]
      @current_user = 2
      expect(show_claim_pending?(@user_signed_in, @current_user, @location)).to be_false
    end
  end
  
  describe 'Rendering Buttons' do
    
    before(:each) do
      @user_signed_in = true
      @location = Location.new(true)
    end
    
    describe 'Rendering the Message Button' do

      it 'should return the button html if the user is signed in' do
        expect(render_message_button(@user_signed_in)).not_to be_empty 
      end
      
      it 'should be false if user not signed in' do
        @user_signed_in = false
        expect(render_message_button(@user_signed_in)).to be_false 
      end
    end
  end
end
