class CouponsController < ApplicationController

  load_and_authorize_resource :location, except: [:redeem]
  load_and_authorize_resource :coupon, through: [:location], except: [:redeem]

  # GET /coupons
  # GET /coupons.json
  def index
    @coupons = @location.coupons

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @coupons }
    end
  end

  # GET /coupons/1
  # GET /coupons/1.json
  def show
    add_crumb '<i class="icon-home"></i> Home'.html_safe, @base_path
    add_crumb @location.name, "#{@base_path}business/#{@location.slug}"
    add_crumb @coupon.name
  end

  # GET /coupons/new
  # GET /coupons/new.json
  def new
    @coupon = @location.coupons.new(expiration: Date.today + 6.months)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @coupon }
    end
  end

  # GET /coupons/1/edit
  def edit

  end

  # POST /coupons
  # POST /coupons.json
  def create
    @coupon = @location.coupons.new(params[:coupon])

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
      if @coupon.update_attributes(params[:coupon])
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
    redemption = Redemption.find(params[:id])
    redemption.redeemed = true
    redemption.save
    location = redemption.coupon.location
    redirect_to location_url(location)
  end

end
