class BusinessImprovementAreasController < ApplicationController
  include PrismicController
  PER_PAGE = 20

  before_action :find_business_improvement_areas, only: [:show]
  load_and_authorize_resource
  # GET /business_improvement_areas
  # GET /business_improvement_areas.json
  def index
    @business_improvement_areas = BusinessImprovementArea.all

    respond_to do |format|
      format.html
      format.json { render json: @business_improvement_areas }
    end
  end

  # GET /business_improvement_areas/1
  # GET /business_improvement_areas/1.json
  def show
    @neighborhood = Neighborhood.find_by_slug(params[:id])

    if @neighborhood.present?
      @district = @neighborhood.district
      @neighbourhoods = @district.neighborhoods
      @city = @district.city
      @municipality = @city.municipality
      @cities = @city.municipality.cities
      @districts = @city.districts
      @sub_neighborhoods = Neighborhood.where(neighborhood_id: @neighborhood.nid)

      key_neighborhood_prismic = "#{@city.slug}-#{@district.slug}-#{@neighborhood.slug}"
      response = api.query(Prismic::Predicates.at("my.location.uid", key_neighborhood_prismic))
      @documents = response.results.present? ? response.results[0]["location.slide_images"] : []

      @status_updates = @neighborhood.status_updates.where(statusable_type: 'Location')
      @news = @neighborhood.news_articles.where(newsable_type: "Location")
      @events = @neighborhood.events
      @media_attachments = @neighborhood.media_attachments
      @blog_entries = @neighborhood.blog_entries
      @products = @neighborhood.products
      @coupons = @neighborhood.coupons
      @services = @neighborhood.services

      if params[:search].present?
        search_community
      end

      if params[:market_id].present?
        filter_community
      end

      @media_attachments = apply_order(@media_attachments).limit(PER_PAGE)
      @blog_entries = apply_order(@blog_entries).limit(PER_PAGE)
      @products = apply_order(@products).limit(PER_PAGE)
      @coupons = apply_order(@coupons).limit(PER_PAGE)
      @services = apply_order(@services).limit(PER_PAGE)
      @status_updates = apply_order(@status_updates).limit(PER_PAGE)
      @news = apply_order(@news).limit(PER_PAGE)
      @events = apply_order(@events, direction: "desc", column: "starts_at").limit(PER_PAGE)
    end

    respond_to do |format|
      format.html { render "neighborhoods/neighborhood_page", layout: "application_v_2" }
    end
  end

  def status_updates
    status_updates = @business_improvement_area.all_status_updates.where("created_at < ?", params[:from]).limit(PER_PAGE)
    render partial: 'business_improvement_areas/status_updates', locals:{ business_improvement_area: @business_improvement_area, status_updates: status_updates }, layout: false
  end

  # GET /business_improvement_areas/new
  # GET /business_improvement_areas/new.json
  def new
    @business_improvement_area = BusinessImprovementArea.new

    respond_to do |format|
      format.html
      format.json { render json: @business_improvement_area }
    end
  end

  # GET /business_improvement_areas/1/edit
  def edit
    @business_improvement_area = BusinessImprovementArea.find(params[:id])
  end

  # POST /business_improvement_areas
  # POST /business_improvement_areas.json
  def create
    @business_improvement_area = BusinessImprovementArea.new(business_improvement_area_params)

    respond_to do |format|
      if @business_improvement_area.save
        format.html { redirect_to @business_improvement_area, notice: 'Business improvement area was successfully created.' }
        format.json { render json: @business_improvement_area, status: :created, location: @business_improvement_area }
      else
        format.html { render action: "new" }
        format.json { render json: @business_improvement_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /business_improvement_areas/1
  # PUT /business_improvement_areas/1.json
  def update
    @business_improvement_area = BusinessImprovementArea.find(params[:id])

    respond_to do |format|
      if @business_improvement_area.update_attributes(business_improvement_area_params)
        format.html { redirect_to @business_improvement_area, notice: 'Business improvement area was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @business_improvement_area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /business_improvement_areas/1
  # DELETE /business_improvement_areas/1.json
  def destroy
    @business_improvement_area = BusinessImprovementArea.find(params[:id])
    @business_improvement_area.destroy

    respond_to do |format|
      format.html { redirect_to business_improvement_areas_url }
      format.json { head :no_content }
    end
  end

  private

  def business_improvement_area_params
    params.require(:business_improvement_area).permit(:description, :district_id, :name, :slug, :home_page_image, :district, :status_updates, :status_updates_attributes, :logo, :website_url, :use_carousel)
  end

  def find_business_improvement_areas
    @business_improvement_area = BusinessImprovementArea.friendly.find(params[:id])
  end
end
