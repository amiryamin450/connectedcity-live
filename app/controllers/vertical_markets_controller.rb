class VerticalMarketsController < ApplicationController
  layout :resolve_layout



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

    set_region
    set_subregion
    set_city
    set_district

    @vertical_market = VerticalMarket.find(params[:market])

    id = @vertical_market.id
    p = params
    region = @region
    sub_region = @sub_region
    city = @city
    district = @district

    results = Location.tire.search do
      query do
        boolean do
          must { term "vertical_market_categories.vertical_market_id", id }
          must { term "categories", p[:category] } unless p[:category].nil?
          must { term "neighborhoods", p[:neighborhood] } unless p[:neighborhood].nil?
          must { term "brands", p[:brand] } unless p[:brand].nil?
          must { term "region.id", region.id } unless region.nil?
          must { term "city.sub_region_id", sub_region.id } unless sub_region.nil?
          must { term "city.id", city.id } unless city.nil?
          must { term "district.id", district.id } unless district.nil?
        end
      end

      # facet 'categories' do
      #   terms :categories, { size: 10 }
      # end
      # facet 'neighborhoods' do
      #   terms :neighborhoods, { size: 10}
      # end
      # facet 'brands' do
      #   terms :brands, {size: 10}
      # end
    end

    @facets = results.facets
    logger.debug "Facets: #{@facets}"
    add_crumb "#{@vertical_market.name} Guide"
  end

  def search

    set_region
    set_subregion
    set_city
    set_district

    @vertical_market = VerticalMarket.find(params[:market])


    query = if params[:query].present?
      {
        multi_match: {
          query: params[:query].downcase,
          fields: [:name, :brands, 'vertical_market.name', 'vertical_market_category.name' ]
        }
      }
    else
      {match_all: {}}
    end

    filters = {}
    filters[:and] = []
    filters[:and] << { term: {"vertical_market_categories.vertical_market_id" => @vertical_market.id}}
    filters[:and] << { term: {"region.id" => @region.id} } unless @region.nil?
    filters[:and] << { term: {"city.sub_region_id" => @subregion.id} } unless @subregion.nil?
    filters[:and] << { term: {"city.id" => @city.id} } unless @city.nil?
    filters[:and] << { term: {"district.id" => @district.id} } unless @district.nil?

    page = params[:page].to_i > 0 ? params[:page].to_i - 1 : params[:page].to_i
    search = Tire.search('locations', query: query, filter: filters, from: page * 10, size: 35 )
    @results = search.results

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
      format.html { redirect_to admin_vertical_markets_url }
      format.json { head :no_content }
    end
  end
end
