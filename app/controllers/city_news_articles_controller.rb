class CityNewsArticlesController < ApplicationController
  load_and_authorize_resource except: [:guide, :index, :filter_updates, :filter_media_attachments, :filter_news_articles, :filter_events]

  PER_PAGE = 20

  # GET /city_news_articles
  # GET /city_news_articles.json
  def index
    @news_articles = CityNewsArticle.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @news_articles }
    end
  end

  def guide
    # determine_area
    # if @area.present?
    #   @city_news_categories = CityNewsCategory.includes(:city_news_articles).where("city_news_articles.#{@area.class.name.downcase}_id = ?", @area.id).all
    # else
    #   @city_news_categories = CityNewsCategory.includes(:city_news_articles).all
    # end
    # districts
    # category_news
    # user_signed_in? ? @favorites = current_user.favorites.all : @favorites = []
    # results = VerticalMarket.order(:name).at_depth 0
    # @vertical_market_news = VerticalMarket.find_by_slug('civic-news')
    # @vertical_markets_all = results.reject{|i| ['civic-news', 'employment-opportunities', 'classifieds'].include?(i.slug)}

    # media = []
    # events_temp = []
    # news_temp = []
    # status_updates_temp = []
    # locations_manicipality.each do |i|
    #   media << i.media_attachments if i.media_attachments.size > 0
    #   events_temp << i.events if i.events.size > 0
    #   news_temp << i.news_articles if i.news_articles.size > 0
    #   status_updates_temp << i.status_updates if i.status_updates.size > 0
    # end
    # @media_attachments = media.flatten.sort_by(&:created_at).reverse
    # @events = events_temp.flatten.sort_by(&:created_at).reverse
    # @news_articles = news_temp.flatten.sort_by(&:created_at).reverse
    # @status_updates = status_updates_temp.flatten.sort_by(&:created_at).reverse

    # render layout: "application_v_2"
  end

  def get_neighborhoods 
    if params[:district_slug].present?
      district = District.find_by_slug(params[:district_slug])
      neighborhoods = district.neighborhoods
      route = "/#{district&.city.slug}/#{district.slug}/guide/news"
      render json: {
        neighborhoods: neighborhoods,
        route: route
      }
    else
      city = City.find_by_slug(params[:city_slug])
      route = "/#{city.slug}/guide/news"
      render json:{
        neighborhoods: [],
        route: route
      }

    end
  end

  def get_sub_neighborhoods
    if params[:neighborhood_slug].present?
      neighborhood = Neighborhood.find_by_slug(params[:neighborhood_slug])
      sub_neis = neighborhood.sub_neighborhoods
      route = "/#{neighborhood&.district&.city&.slug}/#{neighborhood.district&.slug}/#{neighborhood.slug}/guide/news"
      render json: {
        sub_neighborhoods: sub_neis,
        route: route
      }
    else 
      district = District.find_by_slug(params[:district_slug])
      route = "/#{district.city&.slug}/#{district.slug}/guide/news"
      render json: {
        sub_neighborhoods: [],
        route: route
      }
    end
  end

  def get_route_sub_neighborhoods
    if params[:sub_neighborhood_slug].present?
      sub_nei = Neighborhood.find_by_slug(params[:sub_neighborhood_slug])
      route = "/#{sub_nei.neighborhood&.district&.city&.slug}/#{sub_nei.neighborhood&.district&.slug}/#{sub_nei.neighborhood&.slug}/#{sub_nei.slug}/guide/news"
    else
      nei = Neighborhood.find_by_slug(params[:neighborhood_slug])
      route = "/#{nei&.district&.city&.slug}/#{nei.district&.slug}/#{nei.slug}/guide/news"
    end
    render json:{route: route}
  end

  def districts
    # because city is hardcoded everywhere already...
    @districts = District.where("city_id = ?", 5915022)
  end

  def filter_updates
    temp = []
    if params[:category_id].blank?
      locations_manicipality(params[:city_slug], (params[:district_slug]|| params[:district_route]), params[:neighborhood_slug], params[:sub_neighborhood_slug]).each do |i|
        temp << i.status_updates if i.status_updates.length > 0
      end
      @filter_status_updates = temp.flatten.sort_by(&:created_at).reverse
    else
      temp = StatusUpdate.where(category_id: params[:category_id])
      @filter_status_updates = temp.flatten.sort_by(&:created_at).reverse
    end
    respond_to do |format|
      format.js
    end
  end

  def filter_media_attachments
    temp = []
    if params[:category_id].blank?
      locations_manicipality(params[:city_slug], (params[:district_slug]|| params[:district_route]), params[:neighborhood_slug], params[:sub_neighborhood_slug]).each do |i|
        temp << i.media_attachments if i.media_attachments.length > 0
      end
      @filter_media_attachments = temp.flatten.sort_by(&:created_at).reverse
    else
      temp = MediaAttachment.where(category_id: params[:category_id])
      @filter_media_attachments = temp.flatten.sort_by(&:created_at).reverse
    end
    respond_to do |format|
      format.js
    end
  end

  def filter_news_articles
    temp = []
    if params[:category_id].blank?
      locations_manicipality(params[:city_slug], (params[:district_slug]|| params[:district_route]), params[:neighborhood_slug], params[:sub_neighborhood_slug]).each do |i|
        temp << i.news_articles if i.news_articles.length > 0
      end
      @filter_news = temp.flatten.sort_by(&:created_at).reverse
    else
      temp = NewsArticle.where(category_id: params[:category_id])
      @filter_news = temp.flatten.sort_by(&:created_at).reverse
    end
    respond_to do |format|
      format.js
    end
  end

  def filter_events
    temp = []
    if params[:category_id].blank?
      locations_manicipality(params[:city_slug], (params[:district_slug]|| params[:district_route]), params[:neighborhood_slug], params[:sub_neighborhood_slug]).each do |i|
        temp << i.events if i.events.length > 0
      end
      @filter_events = temp.flatten.sort_by(&:created_at).reverse
    else
      temp = Event.where(category_id: params[:category_id])
      @filter_events = temp.flatten.sort_by(&:created_at).reverse
    end
    respond_to do |format|
      format.js
    end
  end

  # GET /city_news_articles/1
  # GET /city_news_articles/1.json
  def show
    @city_news_article = CityNewsArticle.find(params[:id])

    add_crumb '<i class="icon-home"></i> Home'.html_safe, root_path
    add_crumb 'City News', city_news_guide_path
    add_crumb @city_news_article.city_news_category.name, city_news_category_path(@city_news_article.city_news_category)
    add_crumb @city_news_article.title

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @city_news_article }
    end
  end

  # GET /city_news_articles/new
  # GET /city_news_articles/new.json
  def new
    @city_news_article = CityNewsArticle.new
    districts

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @city_news_article }
    end
  end

  # GET /city_news_articles/1/edit
  def edit
    @city_news_article = CityNewsArticle.find(params[:id])
    districts
  end

  # POST /city_news_articles
  # POST /city_news_articles.json
  def create
    @city_news_article = CityNewsArticle.new(params[:city_news_article])

    respond_to do |format|
      if @city_news_article.save
        format.html { redirect_to @city_news_article, notice: 'City news article was successfully created.' }
        format.json { render json: @city_news_article, status: :created, location: @city_news_article }
      else
        format.html { render action: "new" }
        format.json { render json: @city_news_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /city_news_articles/1
  # PUT /city_news_articles/1.json
  def update
    @city_news_article = CityNewsArticle.find(params[:id])

    respond_to do |format|
      if @city_news_article.update_attributes(params[:city_news_article])
        format.html { redirect_to @city_news_article, notice: 'City news article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @city_news_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /city_news_articles/1
  # DELETE /city_news_articles/1.json
  def destroy
    @city_news_article = CityNewsArticle.find(params[:id])
    @city_news_article.destroy

    respond_to do |format|
      format.html { redirect_to city_news_articles_url }
      format.json { head :no_content }
    end
  end

  private

  def determine_area
    klass = [Neighborhood, District, City].detect { |c| params["#{c.name.underscore}_route"]}
    if klass
      @area = klass.find(params["#{klass.name.underscore}_route"])
    end
  end


  def locations_manicipality city_slug, district_slug, neighborhood_slug, sub_neighborhood_slug
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
    else
      location=[]
    end
    if locations.present?
      locations.each do|lo|
        result_locations = Location.where("hall_id = (?) OR councillor_id = (?) OR commissioner_id = (?)", lo.id, lo.id, lo.id)
      end
      other_results = Location.joins(:vertical_market_categories).where(vertical_market_categories: { vertical_market_id: [164, 174, 114]}).where(id: locations.pluck(:id))
    end

    result_locations += other_results
    @locations_of_civic_news ||= result_locations
  end
end
