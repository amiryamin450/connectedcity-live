class EmploymentListingsController < ApplicationController
  PER_PAGE = 20

  load_and_authorize_resource :location, except: [:guide]
  before_filter :load_employment_listing, except: [:guide, :index, :new, :create]
  load_and_authorize_resource :employment_listing, through: [:location], except: [:guide]


  # GET /employment_listings
  # GET /employment_listings.json
  def index
    if user_signed_in? && @location.user_ids.include?(current_user.id)
      @employment_listings = EmploymentListing.unscoped.where(location_id: @location.id)
    else
      @employment_listings = @location.employment_listings
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @employment_listings }
    end
  end

  def guide
    # @employment_categories = EmploymentCategory.includes(:employment_listings).all
    @vertical_market = VerticalMarket.find_by_slug('employment-opportunities')
    @city = City.find(5915022)
    @carousel_images = @city.carousel_images
    @status_updates = @city.status_updates.where(statusable_type: 'Location').limit(PER_PAGE)
    @news = @city.news_articles.where(newsable_type: "Location").limit(PER_PAGE)
    @events = @city.events.order(:starts_at).limit(PER_PAGE)
    @media_attachments = @city.media_attachments.order('created_at DESC').limit(PER_PAGE)
    @districts = @city.districts
    @blog_entries = @city.blog_entries.limit(PER_PAGE)
    @products = @city.products.limit(PER_PAGE)
    @coupons = @city.coupons.limit(PER_PAGE)
    @services = @city.services.limit(PER_PAGE)
    # add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
    # add_crumb 'Employment Opportunities'
    render layout: 'application_v_2'
  end


  # GET /employment_listings/1
  # GET /employment_listings/1.json
  def show
    add_crumb '<i class="icon-home"></i> Home'.html_safe, @base_path
    add_crumb 'Employment Opportunities', employment_opportunity_url
    add_crumb @employment_listing.employment_category.name, employment_category_path(@employment_listing.employment_category)
    add_crumb @location.name, location_path(@location)
    add_crumb @employment_listing.title

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @employment_listing }
    end
  end

  # GET /employment_listings/new
  # GET /employment_listings/new.json
  def new
    @employment_listing = @location.employment_listings.new(application_deadline: Time.now + 2.weeks)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @employment_listing }
    end
  end

  # GET /employment_listings/1/edit
  def edit

  end

  # POST /employment_listings
  # POST /employment_listings.json
  def create
    @employment_listing = @location.employment_listings.new(params[:employment_listing])

    respond_to do |format|
      if @employment_listing.save
        format.html { redirect_to [@location, @employment_listing], notice: 'Employment listing was successfully created.' }
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
      if @employment_listing.update_attributes(params[:employment_listing])
        format.html { redirect_to [@location, @employment_listing], notice: 'Employment listing was successfully updated.' }
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
end
