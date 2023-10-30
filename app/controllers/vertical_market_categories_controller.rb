class VerticalMarketCategoriesController < ApplicationController
  layout :resolve_layout
  load_and_authorize_resource except: [:show_auto_listing_makers, :show]

  def resolve_layout
    case action_name
    when "show", "show_auto_listing_makers", "search"
      "community_guide"
    else
      "application"
    end
  end
  # GET /admin/vertical_market_categories
  # GET /admin/vertical_market_categories.json
  def index

    @search = VerticalMarketCategory.search(params[:q])

    @vertical_market_categories = @search.result.order(:name).page params[:page]

    respond_to do |format|
      format.html
      format.json { render json: @vertical_market_categories }
    end
  end

  # GET /admin/vertical_market_categories/1
  # GET /admin/vertical_market_categories/1.json
  def show
    set_region
    set_subregion
    set_city
    set_district
    set_neighborhood
    set_bia
   
    @vertical_market_category = VerticalMarketCategory.find(params[:id])
    @vertical_market = @vertical_market_category.vertical_market

    add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path

    if @bia
      add_crumb @bia.district.name, district_guide_path(@bia.district) if @bia.district
      add_crumb @bia.name, url_for(@bia)
    end
    @municipality = params[:municipality_slug] ? Municipality.find_by_slug(params[:municipality_slug]) : nil
    @city = params[:city_slug] ? City.find_by_slug(params[:city_slug]) : nil
    @district = params[:district_slug] ? District.find_by_slug(params[:district_slug]) : nil
    @neighborhood = params[:neighborhood_slug] ? Neighborhood.find_by_slug(:neighborhood_slug) : nil
    @sub_neighborhood = params[:sub_neighborhood_slug] ? Neighborhood.find_by_slug(:sub_neighborhood_slug) : nil
    add_crumb @vertical_market_category.vertical_market.parent.name, "#{@base_path}guide/#{@vertical_market_category.vertical_market.parent.slug}" unless @vertical_market_category.vertical_market.parent.nil?
    add_crumb @vertical_market_category.vertical_market.name, "#{@base_path}guide/#{@vertical_market_category.vertical_market.slug}"
    add_crumb @vertical_market_category.name
    respond_to do |format|
      format.html
      format.json { render json: @vertical_market_category }
    end
  end

  def show_auto_listing_makers
    unless params[:make].in? AutomotiveListing.available_in(@municipality.try(:id), @city.id, @district.try(:id), @neighborhood.try(:id), @sub_neigborhood.try(:id)).pluck("DISTINCT make")
      raise Exception.new("AutoMake #{params[:make]} have not appeared in current local yet, city_id: #{@city.id}, district_id: #{@district.try(:id)}, neighborhood_id: #{@neighborhood.try(:id)}")
    end

    @vertical_market = VerticalMarket.where(name: 'Auto Listings').first
    authorize! :show, @vertical_market
    unless @vertical_market_category = @vertical_market.vertical_market_categories.where(name: params[:make]).first
      @vertical_market_category = @vertical_market.vertical_market_categories.create(name: params[:make], slug: params[:make].strip.gsub(' ', '_').downcase)
    end
    crumb_with_fake_category @district.try(:id), @neighborhood.try(:id)
    page = params[:page] || 1
    @auto_make ||= params[:make]
    @auto_listings = @vertical_market_category.get_auto_listings_paged(params[:make], @municipality.try(:id), @city.id, page,
    @district.try(:id), @neighborhood.try(:id), @sub_neigborhood.try(:id))
    @markers = @auto_listings.map(&:location).uniq.map do |location|
      {
        name: location.name,
        url: url_for(location),
        latitude: location.latitude,
        longitude: location.longitude,
        thumb: location.logo.file? ? location.logo.url(:bia_display) : nil
      }
    end.to_json
  end

  # GET /admin/vertical_market_categories/new
  # GET /admin/vertical_market_categories/new.json
  def new
    @vertical_market_category = VerticalMarketCategory.new

    respond_to do |format|
      format.html 
      format.json { render json: @vertical_market_category }
    end
  end

  # GET /admin/vertical_market_categories/1/edit
  def edit
    @vertical_market_category = VerticalMarketCategory.find(params[:id])
  end

  # POST /admin/vertical_market_categories
  # POST /admin/vertical_market_categories.json
  def create
    @vertical_market_category = VerticalMarketCategory.new(vertical_market_category_params)

    respond_to do |format|
      if @vertical_market_category.save
        format.html { redirect_to @vertical_market_category, notice: 'Vertical market category was successfully created.' }
        format.json { render json: @vertical_market_category, status: :created, location: @vertical_market_category }
      else
        format.html { render action: "new" }
        format.json { render json: @vertical_market_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/vertical_market_categories/1
  # PUT /admin/vertical_market_categories/1.json
  def update
    @vertical_market_category = VerticalMarketCategory.find(params[:id])

    respond_to do |format|
      if @vertical_market_category.update_attributes(vertical_market_category_params)
        format.html { redirect_to @vertical_market_category, notice: 'Vertical market category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vertical_market_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/vertical_market_categories/1
  # DELETE /admin/vertical_market_categories/1.json
  def destroy
    @vertical_market_category = VerticalMarketCategory.find(params[:id])
    @vertical_market_category.destroy

    respond_to do |format|
      format.html { redirect_to vertical_market_categories_url }
      format.json { head :no_content }
    end
  end

  private

    def crumb_with_fake_category(district_id = nil, neighborhood_id = nil)
      add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
      add_crumb district.name, district_guide_path(district) if district_id.present? && district.where(id: district_id).first
      add_crumb neighborhood.name if neighborhood_id.present? && neighborhood = Neighborhood.where(id: neighborhood_id).first

      @vertical_market.ancestors.each do |ancestor|
        add_crumb ancestor.name, "#{@base_path}guide/#{ancestor.slug}"
      end

      add_crumb "#{@vertical_market.name}", "#{@base_path}guide/#{@vertical_market.slug}"
      add_crumb "#{@vertical_market_category.name} Lists"
    end

    def vertical_market_category_params
      params.require(:vertical_market_category).permit(:description, :name, :slug, :vertical_market_id, :default_logo, :search_term)
    end
end