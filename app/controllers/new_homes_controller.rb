class NewHomesController < ApplicationController
  load_resource :new_home_community
  load_and_authorize_resource :new_home, through: [:new_home_community]

  # GET /new_homes
  # GET /new_homes.json
  def index
    @location = @new_home_community.location
    @new_homes = @new_home_community.new_homes
    respond_to do |format|
      format.html
      format.json { render json: @new_homes }
    end
  end

  # GET /new_homes/1
  # GET /new_homes/1.json
  def show
    @location = @new_home_community.location
    @vertical_market = @location.vertical_market_categories.first.vertical_market

    add_breadcrumb @district.name, district_guide_path(@district) if @district
    add_breadcrumb @vertical_market.name, "#{@base_path}guide/#{@vertical_market.slug}"
    add_breadcrumb @location.vertical_market_categories.first.name, "#{@base_path}category/#{@location.vertical_market_categories.first.slug}"
    add_breadcrumb @location.name, "#{@base_path}business/#{@location.slug}"
    add_breadcrumb @new_home_community.name, "/business/#{@location.slug}/new_home_communities/#{@new_home_community.slug}"
    add_breadcrumb @new_home.title

    respond_to do |format|
      format.html
      format.json { render json: @new_home }
    end
  end

  # GET /new_homes/new
  # GET /new_homes/new.json
  def new
    @new_home = @new_home_community.new_homes.new

    respond_to do |format|
      format.html 
      format.json { render json: @new_home }
    end
  end

  # GET /new_homes/1/edit
  def edit
    @new_home = NewHome.find(params[:id])
  end

  # POST /new_homes
  # POST /new_homes.json
  def create
    @new_home = @new_home_community.new_homes.new(new_home_params)

    respond_to do |format|
      if @new_home.save
  	    format.html { redirect_to new_home_community_new_homes_path(@new_home_community), notice: 'New home was successfully created.' }
        format.json { render json: @new_home, status: :created, location: @new_home }
      else
        format.html { render action: "new" }
        format.json { render json: @new_home.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /new_homes/1
  # PUT /new_homes/1.json
  def update
    @new_home = NewHome.find(params[:id])

    respond_to do |format|
      if @new_home.update_attributes(new_home_params)
        format.html { redirect_to new_home_community_new_homes_path(@new_home_community), notice: 'New home was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @new_home.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /new_homes/1
  # DELETE /new_homes/1.json
  def destroy
    @new_home = NewHome.find(params[:id])
    @new_home.destroy

    respond_to do |format|
      format.html { redirect_to new_homes_url }
      format.json { head :no_content }
    end
  end

  private

  def new_home_params
    params.require(:new_home).permit(:address, :address_suite, :association_fee, :association_fee_period, :bathroom_comment,
      :bathrooms, :bedroom_comment, :bedrooms, :city_id, :country_id, :description, :detail_view_url,
      :latitude, :living_area, :location_id, :longitude, :neighborhood_id, :postal_code, :province_id, :slug, :title,
      :virtual_tour_url, :year_built, :new_home_community_id, :list_price, :tax_amount, :cover_photo)
  end
end
