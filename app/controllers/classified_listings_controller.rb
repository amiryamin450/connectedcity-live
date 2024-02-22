class ClassifiedListingsController < ApplicationController

  load_and_authorize_resource

  # GET /classified_listings
  # GET /classified_listings.json
  def index
    @classified_listings = if user_signed_in?
      current_user.classified_listings
    else
      []
    end

    respond_to do |format|
      format.html
    end
  end

  def guide
    @vertical_market_classifieds = VerticalMarket.find_by_slug('classifieds')
    districts

    render layout: "application_v_2"
  end

  # GET /classified_listings/1
  # GET /classified_listings/1.json
  def show

    add_breadcrumb '<i class="icon-home"></i> Home'.html_safe, root_path
    add_breadcrumb 'Classifieds', classifieds_path
    add_breadcrumb @classified_listing.classified_category.name, classified_category_path(@classified_listing.classified_category)
    add_breadcrumb @classified_listing.title

    respond_to do |format|
      format.html
      format.json { render json: @classified_listing.classified_images.map { |file| file.to_jq_upload } }
    end
  end

  # GET /classified_listings/new
  # GET /classified_listings/new.json
  def new
    @classified_listing = ClassifiedListing.new(active: true)

    respond_to do |format|
      format.html 
      format.json { render json: @classified_listing }
    end
  end

  # GET /classified_listings/1/edit
  def edit
  end

  # POST /classified_listings
  # POST /classified_listings.json
  def create
    @classified_listing = ClassifiedListing.new(classified_listing_params)
    @classified_listing.user_id = current_user.id
    respond_to do |format|
      if @classified_listing.save
        format.html { render action: "edit" }
        format.json { render json: @classified_listing, status: :created, location: @classified_listing }
      else
        format.html { render action: 'new' }
        format.json { render json: @classified_listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /classified_listings/1
  # PUT /classified_listings/1.json
  def update


    respond_to do |format|
      if @classified_listing.update_attributes(classified_listing_params)
        format.html { redirect_to @classified_listing, notice: 'Classified listing was successfully updated.' }
        format.json { render json: { files: [@classified_listing.classified_images.last.to_jq_upload]}, status: :created, location: @location }
      else
        format.html { render action: "edit" }
        format.json { render json: @classified_listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /classified_listings/1
  # DELETE /classified_listings/1.json
  def destroy
    @classified_listing = ClassifiedListing.find(params[:id])
    @classified_listing.destroy

    respond_to do |format|
      format.html { redirect_to classified_listings_url }
      format.json { head :no_content }
    end
  end

  private

  def districts
    @districts = District.where("city_id = ?", 5915022)
  end

  def classified_listing_params
    params.require(:classified_listing).permit(:condition, :description, :price_cents, :title, :price, :classified_category_id, :address,
      :address_1, :city_id, :province_id, :postal_code, :neighborhood_id, :active, :classified_images_attributes)
  end
end
