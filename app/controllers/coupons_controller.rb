class CouponsController < ApplicationController

  before_action :authenticate_user, only: [:redeem, :claim]

  before_action :load_location, except: [:redeem, :claim]
  load_and_authorize_resource :location, except: [:redeem, :claim]

  before_action :load_coupon, except: [:redeem, :claim, :index, :new, :create]
  load_and_authorize_resource :coupon, through: [:location], except: [:redeem, :claim]
  layout "application_v_2"

  # GET /coupons
  # GET /coupons.json
  def index
    if user_signed_in? && @location.user_ids.include?(current_user.id)
      @coupons = Coupon.unscoped.where(location_id: @location.id)
    else
      @coupons = @location.coupons
    end

    respond_to do |format|
      format.html
      format.json { render json: @coupons }
    end
  end

  # GET /coupons/1
  # GET /coupons/1.json
  def show
    if user_signed_in? && @location.user_ids.include?(current_user.id)
      @coupons = Coupon.unscoped.where(location: @location)
    else
      @coupons = @location.coupons
    end

    add_breadcrumb '<i class="icon-home"></i> Home'.html_safe, @base_path
    add_breadcrumb @location.name, "#{@base_path}business/#{@location.slug}"
    add_breadcrumb @coupon.name
  end

  # GET /coupons/new
  # GET /coupons/new.json
  def new
    @coupon = @location.coupons.new(expiration: Date.today + 6.months)

    respond_to do |format|
      format.html
      format.json { render json: @coupon }
    end
  end

  # GET /coupons/1/edit
  def edit

  end

  # POST /coupons
  # POST /coupons.json
  def create
    @coupon = @location.coupons.new(coupon_params)

    respond_to do |format|
      if @coupon.save
        format.html { redirect_to [@location, @coupon], notice: 'Coupon was successfully created.' }
        format.json { render json: @coupon, status: :created, location: @coupon }
      else
        format.html { render action: "new" }
        format.json { render json: @coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /coupons/1
  # PUT /coupons/1.json
  def update
    @coupon = Coupon.find(params[:id])

    respond_to do |format|
      if @coupon.update(coupon_params)
        format.html { redirect_to [@location, @coupon], notice: 'Coupon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @coupon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coupons/1
  # DELETE /coupons/1.json
  def destroy
    @coupon = Coupon.find(params[:id])
    @coupon.destroy

    respond_to do |format|
      format.html { redirect_to location_coupons_url }
      format.json { head :no_content }
    end
  end

  def claim
    @coupon = Coupon.find(params[:id])
    @coupon.redemptions.create(user_id: current_user.id, redeemed: false)
    redirect_to coupons_user_path(current_user)
  end

  def redeem
    redemption = current_user.redemptions.find(params[:id])
    redemption.redeemed = true
    redemption.save
    location = redemption.coupon.location
    redirect_to location_url(location)
  end

  private

  def load_coupon
    if user_signed_in? && @location.user_ids.include?(current_user.id)
      @coupon = Coupon.unscoped.where(location_id: @location.id).find(params[:id])
    else
      @coupon = @location.coupons.find params[:id]
    end
  end

  def load_location
    @location = Location.friendly.find(params[:location_id])
  end

  def coupon_params
    params.require(:coupon).permit(:description, :expiration, :howmany, :name, :redemptions_count, :code_prefix, :image)
  end
end
