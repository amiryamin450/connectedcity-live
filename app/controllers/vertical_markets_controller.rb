class VerticalMarketsController < ApplicationController
  layout :resolve_layout
  load_and_authorize_resource except: :search


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

  def guide

    @vertical_market = VerticalMarket.find(params[:market])

    case @vertical_market.id
    when 17
      @rental_properties = if @district
        RentalProperty.where(district_id: @district.id).where(city_id: 5915022).order(:name)
      else
        RentalProperty.where(city_id: 5915022).order(:name)
      end
    when 18
      @listings = if @district
        RealEstateListing.where(property_type: 'Residential').where(district_id: @district.id).where(city_id: 5915022).order(:title)
      else
        RealEstateListing.where(property_type: 'Residential').where(city_id: 5915022).order(:title)
      end
    when 20
      @listings = if @district
        RealEstateListing.where(property_type: 'Commercial').where(district_id: @district.id).where(city_id: 5915022).order(:title)
      else
        RealEstateListing.where(property_type: 'Commercial').where(city_id: 5915022).order(:title)
      end
    when 19
      @new_home_communities = if @district
        NewHomeCommunity.where(district_id: @district.id).where(city_id: 5915022).order(:name)
      else
        NewHomeCommunity.where(city_id: 5915022).order(:name)
      end
    else
    end
    add_crumb '<i class="icon-home"></i> Home'.html_safe, @base_path
    add_crumb @district.name, district_guide_path(@district) if params[:district_route].present?
    add_crumb "#{@vertical_market.name} Guide"
  end

  def search
    vm = nil
    vm = VerticalMarket.find(params[:market]) if params[:market].present?
    district = District.find(params[:district_route]) if params[:district_route].present?
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


    @search = Location.solr_search do
      fulltext params[:search]
      with(:city_id, 5915022)
      with(:vertical_market_ids, ids) if vm.present?
      with(:district_id, district.id) if district.present?
    end

    @results = @search.results

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
end
