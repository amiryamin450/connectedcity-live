class UserController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource except: [:release_coupon, :coupons, :favorites]

  skip_before_filter :require_no_authentication, :only => [:new, :create]

  def index

    @users = User.order(:first_name)
    respond_to do |format|
      format.html
      format.json { render json: @users.order(:email).where("email like ?", "%#{params[:q]}%") }
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
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
      @user.update_attributes(params[:user])
    else
      @user.update_without_password(params[:user])
    end



    if @user.update_attributes(params[:user])
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
    @vertical_markets = VerticalMarket.all
    @user = User.find(params[:id])

  end

  def coupons
    @coupons = current_user.coupons.where('redemptions.redeemed' => false)
  end

  def release_coupon
    redemption = Redemption.find(params[:id])
    redemption.destroy
    redirect_to coupons_user_path(current_user)
  end

end
