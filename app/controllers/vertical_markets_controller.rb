class VerticalMarketsController < ApplicationController
  layout :resolve_layout
  load_and_authorize_resource except: [:search, :guide]

  def resolve_layout
    case action_name
    when "guide", "search"
      "community_guide"
    else
      "application"
    end
  end

  # GET /vertical_markets
  # GET /vertical_markets.json
  def index
    @vertical_markets = VerticalMarket.roots
    @test = VerticalMarket.roots

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vertical_markets }
    end
  end

  # GET /vertical_markets/1
  # GET /vertical_markets/1.json
  def show
    @vertical_market = VerticalMarket.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vertical_market }
    end
  end


  #This is the action that controls the vertical market category pages. Not sure why it's an action called Guide when there is a Guide controller...sigh... -Don Marges
  # Pretty sure it was named guide because its creator is out of ideas and obviously, it guide the instance variables @abc to the right values ...sneer... -Tom Tran
  def guide
    categories_without_municipality
    @vertical_market = VerticalMarket.includes(vertical_market_categories: :locations).find(params[:market])
    case @vertical_market.id
    when 1
      @auto_listings = AutomotiveListing.limit(SEE_MORE_LIMIT)
    when 17
      @rental_properties = RentalProperty.where city_id: @city.id
      @rental_properties = @rental_properties.where district_id: @district.id if @district
      @rental_properties = @rental_properties.where neighborhood_id: @neighborhood.id if @neighborhood
      @rental_properties = @rental_properties.order :style
      @rental_styles = @rental_properties.map(&:style).uniq
    when 18
      @listings = RealEstateListing.where property_type: 'Residential', city_id: @city.id
      @listings = @listings.where district_id: @district.id if @district
      @listings = @listings.where neighborhood_id: @neighborhood.id if @neighborhood
      @listings = @listings.order :style
      @residential_styles =  @listings.uniq.pluck(:style)
    when 19
      @new_home_communities = NewHomeCommunity.where city_id: @city.id
      @new_home_communities = @new_home_communities.where district_id: @district.id if @district
      @new_home_communities = @new_home_communities.where neighborhood_id: @neighborhood.id if @neighborhood
      @new_home_communities = @new_home_communities.order :style
      @new_home_community_styles = @new_home_communities.pluck(:style).uniq
    when 20
      @commercial_listings = RealEstateListing.where property_type: 'Commercial',
                                                     city_id: @city.id
      @commercial_listings = @commercial_listings.where district_id: @district.id if @district
      @commercial_listings = @commercial_listings.where neighborhood_id: @neighborhood.id if @neighborhood
      @commercial_listings = @commercial_listings.order :style
      @commercial_styles = @commercial_listings.uniq.pluck(:style)
    end

    if @vertical_market.name.include?("Auto Listing")
      @auto_listings = {}
      @auto_makes = AutomotiveListing.pluck("DISTINCT make")
      @auto_makes.each do |make|
        @auto_listings[make] = AutomotiveListing.make_by(make).
          available_in(@city.id, @district.try(:id), @neighborhood.try(:id)).limit(SEE_MORE_LIMIT).includes(:location)
      end
      @markers = @auto_listings.values.flatten.map(&:location)
    end

    add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
    add_crumb @district.name, district_guide_path(@district) if @district
    add_crumb @neighborhood.name if @neighborhood

    @vertical_market.ancestors.each do |ancestor|
      add_crumb ancestor.name, "#{@base_path}guide/#{ancestor.slug}"
    end

    add_crumb "#{@vertical_market.name} Guide"
    render layout: "application_v_2"
  end

  def search
    vm = nil
    vm = VerticalMarket.find(params[:market]) if params[:market].present?
    district = District.find(params[:district_route]) if params[:district_route].present?
    neighborhood = Neighborhood.find(params[:neighborhood]) if params[:neighborhood].present?
    @bia = BusinessImprovementArea.find(params[:business_improvement_area]) if params[:business_improvement_area].present?
    @vertical_market = vm if vm.present?



    ids = if vm.present?
      if vm.has_children?
        vm.children.map(&:id) + [vm.id]
      else
        vm.id
      end
    else
      nil
    end

    @search = Sunspot.search Location, AutomotiveListing, RealEstateListing do
      fulltext params[:search]

      with(:city_id, 5915022)
      with(:vertical_market_ids, ids) if vm.present?
      with(:district_id, district.id) if district.present?
      with(:business_improvement_area_id, @bia.id) if @bia.present?
      with(:neighborhood_id, neighborhood.id) if neighborhood.present?
      paginate :page => params[:page]
    end

    @results = @search.results

    add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
    add_crumb @district.name, district_guide_path(@district) if @district

    if @vertical_market.present?
      @vertical_market.ancestors.each do |ancestor|
        add_crumb ancestor.name, "#{@base_path}guide/#{ancestor.slug}"
      end
    end

    add_crumb @vertical_market.name, "#{@base_path}guide/#{@vertical_market.slug}" if @vertical_market

    add_crumb 'Search Results'
  end

  # GET /vertical_markets/new
  # GET /vertical_markets/new.json
  def new
    @vertical_market = VerticalMarket.new
    #@vertical_markets = VerticalMarket.arrange_as_array(:order => 'name', @vertical_market.possible_parents)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vertical_market }
    end
  end

  # GET /vertical_markets/1/edit
  def edit
    @vertical_market = VerticalMarket.find(params[:id])
    #@vertical_markets = VerticalMarket.arrange_as_array(:order => 'name', @vertical_market.possible_parents)
  end

  # POST /vertical_markets
  # POST /vertical_markets.json
  def create
    @vertical_market = VerticalMarket.new(params[:vertical_market])

    respond_to do |format|
      if @vertical_market.save
        format.html { redirect_to  @vertical_market, notice: 'Vertical market was successfully created.' }
        format.json { render json: @vertical_market, status: :created, location: @vertical_market }
      else
        format.html { render action: "new" }
        format.json { render json: @vertical_market.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vertical_markets/1
  # PUT /vertical_markets/1.json
  def update
    @vertical_market = VerticalMarket.find(params[:id])

    respond_to do |format|
      if @vertical_market.update_attributes(params[:vertical_market])
        format.html { redirect_to @vertical_market, notice: 'Vertical market was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vertical_market.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vertical_markets/1
  # DELETE /vertical_markets/1.json
  def destroy
    @vertical_market = VerticalMarket.find(params[:id])
    @vertical_market.destroy

    respond_to do |format|
      format.html { redirect_to vertical_markets_url }
      format.json { head :no_content }
    end
  end

  def get_rental_unit_styles
	[
	  'Condominiums', 'Houses', 'Townhomes'
	]
  end

  def categories_without_municipality
    name_categories = [
      'Mayor',
      'Deputy Major',
      'City Manager',
      'Deputy City Manager',
      'Chief Financial Officer',
      'Police Chief',
      'Fire Chief',
      'Director of Economic Development',
      'Director of City Planning',
      'Director of Public Works',
      'Chief Human Resources Officer',
      'Chief Legal Officer',
      'General Manager - Art, Culture & Community',
      'General Manager - Buildings, Development & Listings',
      'General Manager - Engineering Services',
      'Chief Communications Officer',
      'City Councillors',
      'Parks & Recreation Commissioners'
    ]
    @categories_without_municipality_ids = VerticalMarketCategory.where(name: name_categories).pluck(:id)
  end
end
