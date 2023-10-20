class RealEstateListingsController < ApplicationController
  load_and_authorize_resource :location
  load_and_authorize_resource :real_estate_listing, through: :location

  # GET /real_estate_listings
  # GET /real_estate_listings.json
  def index
    @real_estate_listings = @location.real_estate_listings
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @real_estate_listings }
    end
  end

  # GET /real_estate_listings/1
  # GET /real_estate_listings/1.json
  def show

    @vertical_market = @location.vertical_market_categories.first.vertical_market

    add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
    add_crumb @location.district.name, district_guide_path(@location.district) if @location.district
    add_crumb @location.neighborhood.name if @location.neighborhood

    add_crumb @vertical_market.name, "#{@base_path}guide/#{@vertical_market.slug}"
    add_crumb @location.vertical_market_categories.first.name, "#{@base_path}category/#{@location.vertical_market_categories.first.slug}"
    add_crumb @location.name, "#{@base_path}business/#{@location.slug}"
    add_crumb @real_estate_listing.title

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json:  @real_estate_listing.real_estate_listing_images.map{|file| file.to_jq_upload }  }
    end
  end

  # GET /real_estate_listings/new
  # GET /real_estate_listings/new.json
  def new
    @real_estate_listing = @location.real_estate_listings.new
    @real_estate_listing_styles = get_real_estate_listing_styles 
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @real_estate_listing }
    end
  end

  # GET /real_estate_listings/1/edit
  def edit
    @real_estate_listing = RealEstateListing.find(params[:id])
    @selected_listing_style = @real_estate_listing.style
    @real_estate_listing_styles = get_real_estate_listing_styles

    #removes empty string from array of styles
    @real_estate_listing_styles.delete_if { |style| !style.present? }
  end

  # POST /real_estate_listings
  # POST /real_estate_listings.json
  def create
    @real_estate_listing = @location.real_estate_listings.new(real_estate_listing_params)

    respond_to do |format|
      if @real_estate_listing.save
        format.html { redirect_to [@location, @real_estate_listing], notice: 'Real estate listing was successfully created.' }
        format.json { render json: @real_estate_listing, status: :created, location: @real_estate_listing }
      else
        format.html { render action: "new" }
        format.json { render json: @real_estate_listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /real_estate_listings/1
  # PUT /real_estate_listings/1.json
  def update


    respond_to do |format|
      if @real_estate_listing.update_attributes(real_estate_listing_params)
        format.html { redirect_to [@location, @real_estate_listing], notice: 'Real estate listing was successfully updated.' }
        format.json { render json: { files: [@real_estate_listing.real_estate_listing_images.last.to_jq_upload]}, status: :created, location: @location }
      else
        format.html { render action: "edit" }
        format.json { render json: @real_estate_listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /real_estate_listings/1
  # DELETE /real_estate_listings/1.json
  def destroy

    @real_estate_listing.destroy

    respond_to do |format|
      format.html { redirect_to location_real_estate_listings_url }
      format.json { head :no_content }
    end
  end

  private

  def get_real_estate_listing_styles
	[
	  'Apartments',
	  'Condominiums',
	  'Houses',
	  'Townhomes'
	]
  end

  def real_estate_listing_params
    params.require(:real_estate_listing).permit(
      :listing_source,
      :email,
      :web_bug_url,
      :listing_source_id,
      :provider_listing_id,
      :provider,
      :regional_mls_number,
      :regional_mls_number_visible,
      :last_update_date,
      :status,
      :title,
      :detail_view_url,
      :country,
      :province,
      :address,
      :address_visible,
      :address_suite,
      :postal_code,
      :latitude,
      :longitude,
      :city,
      :description,
      :list_price,
      :tax_amount,
      :property_type,
      :style,
      :lot_comment,
      :lot_legal,
      :rental_price,
      :rental_period,
      :rental_currency,
      :bedrooms,
      :bedroom_comment,
      :bathrooms,
      :bathroom_comment,
      :garage,
      :garage_stalls,
      :garage_style,
      :garage_comment,
      :living_area,
      :living_area_unit,
      :year_built,
      :year_built_comment,
      :broker_name,
      :list_date,
      :virtual_tour_url,
      :association_fee,
      :association_fee_period,
      :association_fee_currency,
      :neighborhood,
      :location,
      :slug,
      :city_id,
      :country_id,
      :province_id,
      :location_id,
      :main_image,
      :real_estate_listing_images,
      :district_id,
      :neighborhood_id,
      :status_updates_attributes,
      :real_estate_listing_images_attributes
    )
  end
end
