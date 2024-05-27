class UserController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource except: [:release_coupon, :coupons, :favorites]

  # skip_before_action :require_no_authentication, :only => [:new, :create]
  layout "application_v_2", only: [:coupons]

  def index
    @users = User.order(:first_name)
    @users = @users.page(params[:page])

    respond_to do |format|
      format.html { render layout: 'application_v_2' }
      format.json { render json: @users.order(:email).where("email like ?", "%#{params[:q]}%") }
    end
  end

  def show
    @user = User.find(params[:id])
    @slug = @user.name.presence || @user.email.presence
    @location = Location.unscoped.find_or_initialize_by(slug: @slug.parameterize)

    if @location.new_record?
      init_empty_location
      @location.save!
    end

    @media_attachments = @location.media_attachments.order('created_at DESC').limit(20)
    @status_updates = @location.status_updates

    if params[:edit].present?
      redirect_to edit_location_path(@location)
    else
      respond_to do |format|
        format.html { render layout: 'application_v_2' }
        format.json { render json: @user }
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to user_index_path, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end

    end
  end

  def update
    @user = User.find(params[:id])

    password_changed = !params[:user][:password].empty?

    successfully_updated = if password_changed
      @user.update(params[:user])
    else
      @user.update_without_password(params[:user])
    end

    if @user.update(params[:user])
      redirect_to user_index_path, :notice => "User updated."
    else
      redirect_to user_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to user_index_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

  def bulk_delete
    return redirect_to user_index_path unless params[:user_ids].present?

    users = User.where(id: params[:user_ids])
    users.destroy_all

    respond_to do |format|
      format.html { redirect_to user_index_url }
      format.json { render json: { success: true}  }
    end
  end

  def autocomplete
  end

  def make_admin
    user = User.find(params[:id])
    user.add_role :admin
    user.save

    redirect_to user_index_path
  end

  def remove_admin
    user = User.find(params[:id])
    user.remove_role :admin
    user.save
    redirect_to user_index_path
  end

  def favorites
    if params[:name].present?
      @vertical_market = VerticalMarket.find_by(slug: params[:name])
      @vertical_markets = [@vertical_market].compact
    else
      @vertical_markets = VerticalMarket.where(ancestry_depth: 0)
    end

    @user = User.find(params[:id])

    if params[:name].present? && params[:name] == 'associations'
      slug = @user.name.presence || @user.email.presence
      location = Location.unscoped.find_by(slug: slug.parameterize)
      @trade_associations = location&.trade_associations
      ids = []
      @trade_associations.each do |association|
        ids << association.locations.ids
      end
      @status_updates = StatusUpdate.where(statusable_id: ids.flatten.uniq)
    else
      vm_slugs = []
      @vertical_markets.each do |vm|
        vm_slugs << vm.slug
        vm_slugs << vm.children.pluck(:slug) if vm.has_children?
      end
      vm_slugs = vm_slugs.flatten.uniq

      favorites = Favorite.where(user_id: params[:id]).where(category: vm_slugs)
      @status_updates = StatusUpdate.where(statusable_id: favorites.pluck(:location_id))
    end

    location_ids = Favorite.where(user_id: params[:id]).pluck(:location_id).compact
    @friend_locations = Location.unscoped.joins(:vertical_market_categories).where("locations.id IN (?)", location_ids).where("vertical_market_categories.name = ?", "ConnectedCitizen")

    respond_to do |format|
      format.html { render layout: 'application_v_2' }
    end
  end

  def coupons
    @coupons = current_user.coupons.where('redemptions.redeemed' => false)
  end

  def release_coupon
    redemption = Redemption.find(params[:id])
    redemption.destroy
    redirect_to coupons_user_path(current_user)
  end

  def update_profile
    @location = current_user.profile
    @location.logo = params[:location][:logo] if params[:location][:logo].present?
    @location.cover_photo = params[:location][:cover_photo] if params[:location][:cover_photo].present?

    if @location.save
      flash[:success] = "Profile updated"
    else
      flash[:error] = "Failed to update profile"
    end

    redirect_to edit_user_registration_path
  end

  private

  def init_empty_location
    @location.is_profile = true
    @location.content = ''
    @location.name = @slug
    @location.email = @user.email
    @location.vertical_market_categories << VerticalMarketCategory.find_by_slug('connectedcitizen')
  end
end
