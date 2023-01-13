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
    market_param = params[:market] === 'news' ? 'civic-news' : params[:market]
    @vertical_market = VerticalMarket.includes(vertical_market_categories: :locations).find(market_param)

        # init_category_values
    if params[:market] === 'news'
      districts
      neighborhoods
      sub_neighborhoods
      cities

      media = []
      events_temp = []
      news_temp = []
      status_updates_temp = []
      locations_of_civic_news(params[:municipality_slug], params[:city_slug], (params[:district_slug]|| params[:district_route]), params[:neighborhood_slug], params[:sub_neighborhood_slug]).each_with_index do |i, idx|
        media_filter = i.media_attachments
        events_filter = i.events
        news_filter = i.news_articles
        status_update_filter = i.status_updates
        if params[:search].present?
          media_filter = i.media_attachments.where("media_attachments.title LIKE ? OR media_attachments.description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if i.media_attachments.size > 0
          events_filter = i.events.where("events.name LIKE ? OR events.description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if i.events.size >0
          news_filter = i.news_articles.where("news_articles.title LIKE ? OR news_articles.content LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if i.news_articles.size >0 
          status_update_filter = i.status_updates.where("status_updates.title LIKE ? OR status_updates.content LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if i.status_updates.size >0
        end
        if params[:market_id].present?
          media_filter = i.media_attachments.where(category_id: params[:market_id]) if i.media_attachments.size >0
          events_filter = i.events.where(category_id: params[:market_id]) if i.events.size >0
          news_filter = i.news_articles.where(category_id: params[:market_id]) if i.news_articles.size >0
          status_update_filter = i.status_updates.where(category_id: params[:market_id]) if i.status_updates.size >0
        end
        
        media << media_filter if media_filter.size > 0
        events_temp << events_filter if events_filter.size > 0
        news_temp << news_filter if news_filter.size > 0
        status_updates_temp << status_update_filter if status_update_filter.size > 0
      end

      @media_attachments = media.flatten.sort_by(&:created_at).reverse
      @events = events_temp.flatten.sort_by(&:created_at).reverse
      @news_articles = news_temp.flatten.sort_by(&:created_at).reverse
      @status_updates = status_updates_temp.flatten.sort_by(&:created_at).reverse
      names = ['Provincial Updates', 'Federal Updates']
      lst_categories = Category.where(name: names)
      @categories_news += lst_categories

      @municipality = params[:municipality_slug] ? Municipality.find_by_slug(params[:municipality_slug]) : nil
      @city = params[:city_slug] ? City.find_by_slug(params[:city_slug]) : nil
      district_slug = params[:district_route] || params[:district_slug]
      @district = district_slug ? District.find_by_slug(district_slug) : nil
      neighborhood_slug = params[:neighborhood_slug]
      @neighborhood = neighborhood_slug ? Neighborhood.find_by_slug(neighborhood_slug) : nil
      @sub_neighborhood = params[:sub_neighborhood_slug] ? @neighborhood.sub_neighborhoods.find_by_slug(params[:sub_neighborhood_slug]) : nil
      if params[:city_slug] || district_slug || neighborhood_slug || params[:sub_neighborhood_slug]
        @municipality_of_city = @city.municipality
        @region_of_city = @municipality_of_city.region
        @province_of_city = @region_of_city.province
      end
    else
      @municipality = params[:municipality_slug] ? Municipality.find_by_slug(params[:municipality_slug]) : nil
      @city = params[:city_slug] ? City.find_by_slug(params[:city_slug]) : nil
      district_slug = params[:district_route] || params[:district_slug]
      @district = district_slug ? District.find_by_slug(district_slug) : nil

      neighborhood_slug = params[:neighborhood_slug]
      @neighborhood = neighborhood_slug ? Neighborhood.find_by_slug(neighborhood_slug) : nil
      @sub_neighborhood = params[:sub_neighborhood_slug] ? @neighborhood.sub_neighborhoods.find_by_slug(params[:sub_neighborhood_slug]) : nil
      @sub_market = @vertical_market.children&.find_by_slug(params[:sub_market]) if params[:sub_market]

      categories_without_municipality
      case @vertical_market.id
      when 1
        @auto_listings = AutomotiveListing.limit(SEE_MORE_LIMIT)
      when 17
        if @municipality.present?
          city_ids = @municipality.cities.pluck(:id)
          @rental_properties = RentalProperty.where city_id: city_ids
        else
          @rental_properties = RentalProperty.where city_id: @city.id
        end
        @rental_properties = @rental_properties.where district_id: @district.id if @district
        @rental_properties = @rental_properties.where neighborhood_id: @neighborhood.id if @neighborhood
        @rental_properties = @rental_properties.order :style
        @rental_styles = @rental_properties.map(&:style).uniq
      when 18
        if @municipality.present?
          city_ids = @municipality.cities.pluck(:id)
          @listings = RealEstateListing.where property_type: 'Residential', city_id: city_ids
        else
          @listings = RealEstateListing.where property_type: 'Residential', city_id: @city.id
        end
        @listings = @listings.where district_id: @district.id if @district
        @listings = @listings.where neighborhood_id: @neighborhood.id if @neighborhood
        @listings = @listings.order :style
        @residential_styles =  @listings.uniq.pluck(:style)
      when 19
        if @municipality.present?
          city_ids = @municipality.cities.pluck(:id)
          @new_home_communities = NewHomeCommunity.where city_id: city_ids
        else
          @new_home_communities = NewHomeCommunity.where city_id: @city.id
        end
        @new_home_communities = @new_home_communities.where district_id: @district.id if @district
        @new_home_communities = @new_home_communities.where neighborhood_id: @neighborhood.id if @neighborhood
        @new_home_communities = @new_home_communities.order :style
        @new_home_community_styles = @new_home_communities.pluck(:style).uniq
      when 20
        if @municipality.present?
          city_ids = @municipality.cities.pluck(:id)
          @commercial_listings = RealEstateListing.where property_type: 'Commercial',municipality_id: city_ids
        else
          @commercial_listings = RealEstateListing.where property_type: 'Commercial',city_id: @city.id
        end
       
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
            available_in(@municipality.try(:id), @city.try(:id), @district.try(:id), @neighborhood.try(:id), @sub_neigborhood.try(:id)).limit(SEE_MORE_LIMIT).includes(:location)
        end
        @markers = @auto_listings.values.flatten.map(&:location)
      end

      add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
      add_crumb @district.name, district_guide_path(@district) if @district
      add_crumb @neighborhood.name if @neighborhood
      add_crumb @sub_neigborhood.name if @sub_neigborhood

      @vertical_market.ancestors.each do |ancestor|
        add_crumb ancestor.name, "#{@base_path}guide/#{ancestor.slug}"
      end

      @vertical_market.ancestors.each do |ancestor|
        add_crumb ancestor.name, "#{@base_path}guide/#{ancestor.slug}"
      end

      add_crumb "#{@vertical_market.name} Guide"
    end
    render layout: "application_v_2"
  end

  def search
    vm = nil
    vm = VerticalMarket.find(params[:market]) if params[:market].present?
    @municipality = municipality = Municipality.find_by_slug(params[:municipality_slug]) if params[:municipality_slug]
    @city = city  = City.find_by_slug(params[:city_slug]) if params[:city_slug].present?
    @district = district = District.find_by_slug(params[:district_slug]) if params[:district_slug].present?
    @neighborhood = neighborhood = Neighborhood.find_by_slug(params[:neighborhood_slug]) if params[:neighborhood_slug].present?
    @sub_neighborhood = sub_neighborhood = Neighborhood.find_by_slug(params[:neighborhood_slug]) if params[:sub_neigborhood_slug].present?
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
      with(:vertical_market_ids, ids) if vm.present?
      with(:sub_neighborhood_id, sub_neighborhood.id) if sub_neighborhood.present?
      with(:neighborhood_id, neighborhood.id) if neighborhood.present?
      with(:district_id, district.id) if district.present?
      with(:city_id, city.id) if city.present?
      with(:municipality_id, municipality.id) if municipality.present?
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

  def cities
    # because city is hardcoded everywhere already...
    if params[:city_slug].present?
      city = City.find_by_slug(params[:city_slug])
      @cities = city.municipality.cities
    elsif params[:municipality_slug].present?
      municipality = Municipality.find_by_slug(params[:municipality_slug])
      @cities = municipality.cities
    else
      @cities = []
    end
  end

  def districts
    # because city is hardcoded everywhere already...
    if params[:city_slug].present?
      city = City.find_by_slug(params[:city_slug])
      @districts = city.districts
    else
      @districts = []
    end
  end

  def neighborhoods
    # because city is hardcoded everywhere already...
    if params[:district_slug].present? || params[:district_route].present?
      dis = District.find_by_slug(params[:district_slug]|| params[:district_route])
      @neighborhoods = dis.neighborhoods
    else
      @neighborhoods = []
    end
  end

  def sub_neighborhoods 
    # because city is hardcoded everywhere already...
    if params[:neighborhood_slug].present?
      nei = Neighborhood.find_by_slug(params[:neighborhood_slug])
      @sub_neighborhoods = nei.sub_neighborhoods
    else
      @sub_neighborhoods = []
    end
  end


  def locations_of_civic_news municipality_slug, city_slug, district_slug, neighborhood_slug, sub_neighborhood_slug
    result_locations = []
    locations =[]
    other_results =[]

    if sub_neighborhood_slug.present?
      sub_nei = Neighborhood.find_by_slug(sub_neighborhood_slug)
      locations = Location.where(sub_neighborhood_id: sub_nei.id)
    elsif neighborhood_slug.present?
      nei = Neighborhood.find_by_slug(neighborhood_slug)
      locations = nei.locations
    elsif district_slug.present?
      district = District.find_by_slug(district_slug)
      locations = district.locations
    elsif city_slug.present?
      city = City.find_by_slug(city_slug)
      locations = city.locations
    elsif municipality_slug.present?
      municipality = Municipality.find_by_slug(municipality_slug)
      locations = municipality.locations
    else
      locations=[]
    end
    if locations.present?
      result_locations = Location.where("hall_id in (?) OR councillor_id in (?) OR commissioner_id in (?)", locations.pluck(:id), locations.pluck(:id), locations.pluck(:id))
      # [164, 174, 114]
      other_results = Location.joins(:vertical_market_categories).where(vertical_market_categories: { vertical_market_id: [164, 174, 114]}).where(id: locations.pluck(:id))
    end
    
    result_locations += other_results
    @locations_of_civic_news ||= result_locations
  end
end
