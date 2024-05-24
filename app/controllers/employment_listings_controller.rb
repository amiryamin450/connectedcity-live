class EmploymentListingsController < ApplicationController
  PER_PAGE = 20

  before_action :set_location, only: [:index, :new, :create, :edit, :update, :show, :destroy]
  load_and_authorize_resource :location, except: [:guide]
  before_action :load_employment_listing, except: [:guide, :index, :new, :create]
  load_and_authorize_resource :employment_listing, through: [:location], except: [:guide]
  layout "application_v_2"

  # GET /employment_listings
  # GET /employment_listings.json
  def index
    if user_signed_in? && @location.user_ids.include?(current_user.id)
      @employment_listings = EmploymentListing.unscoped.where(location_id: @location.id)
    else
      @employment_listings = @location.employment_listings
    end

    respond_to do |format|
      format.html
      format.json { render json: @employment_listings }
    end
  end

  def guide
    @vertical_market = VerticalMarket.find_by_slug('employment-opportunities')
    @city = City.find(5915022)
    @carousel_images = @city.carousel_images
    @status_updates = @city.status_updates.where(statusable_type: 'Location').limit(PER_PAGE).order('created_at DESC')
    @news = @city.news_articles.where(newsable_type: "Location").limit(PER_PAGE).order('created_at DESC')
    @events = @city.events.order(:starts_at).limit(PER_PAGE)
    @media_attachments = @city.media_attachments.order('created_at DESC').limit(PER_PAGE)
    @districts = @city.districts
    @blog_entries = @city.blog_entries.limit(PER_PAGE).order('created_at DESC')
    @products = @city.products.limit(PER_PAGE).order('created_at DESC')
    @coupons = @city.coupons.limit(PER_PAGE).order('created_at DESC')
    @services = @city.services.limit(PER_PAGE).order('created_at DESC')
    render layout: 'application_v_2'
  end


  # GET /employment_listings/1
  # GET /employment_listings/1.json
  def show
    add_breadcrumb '<i class="icon-home"></i> Home'.html_safe, @base_path
    add_breadcrumb 'Employment Opportunities', employment_opportunity_url
    add_breadcrumb @employment_listing.employment_category.name, employment_category_path(@employment_listing.employment_category)
    add_breadcrumb @location.name, location_path(@location)
    add_breadcrumb @employment_listing.title

    respond_to do |format|
      format.html
      format.json { render json: @employment_listing }
    end
  end

  # GET /employment_listings/new
  # GET /employment_listings/new.json
  def new
    @employment_listing = @location.employment_listings.new(application_deadline: Time.now + 2.weeks)

    respond_to do |format|
      format.html
      format.json { render json: @employment_listing }
    end
  end

  # GET /employment_listings/1/edit
  def edit

  end

  # POST /employment_listings
  # POST /employment_listings.json
  def create
    @employment_listing = @location.employment_listings.new(employment_listing_params)

    respond_to do |format|
      if @employment_listing.save!
        format.html { redirect_to action: :index, notice: 'Employment listing was successfully created.' }
        format.json { render json: @employment_listing, status: :created, location: @employment_listing }
      else
        format.html { render action: "new" }
        format.json { render json: @employment_listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /employment_listings/1
  # PUT /employment_listings/1.json
  def update
    respond_to do |format|
      if @employment_listing.update(employment_listing_params)
        format.html { redirect_to action: :index, notice: 'Employment listing was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @employment_listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employment_listings/1
  # DELETE /employment_listings/1.json
  def destroy
    @employment_listing.destroy

    respond_to do |format|
      format.html { redirect_to location_employment_listings_url }
      format.json { head :no_content }
    end
  end

  private

  def load_employment_listing
    if user_signed_in? && @location.user_ids.include?(current_user.id)
      @employment_listing = EmploymentListing.unscoped.where(location_id: @location.id).find(params[:id])
    else
      @employment_listing = @location.employment_listings.find params[:id]
    end
  end

  def employment_listing_params
    params.require(:employment_listing).permit(:advantages, :application_deadline, :description, :locations, :number,
      :number_of_positions, :qualifications, :title, :location_id, :employment_category_id,
      :cover_photo)
  end

  def set_location
    @location = Location.friendly.find(params[:location_id])
  end
end
