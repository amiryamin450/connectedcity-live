class HomeController < ApplicationController
  layout "application_v_3"
  include PrismicController

  PER_PAGE = 20

  def index
    response = api.query(Prismic::Predicates.at("my.location.uid", "home_page"))
    @documents = response.results.present? ? response.results[0]["location.slide_images"] : []
    @provinces = Province.all.sort_by(&:name)
  end

  def city_landing
    @city = City.find_by_slug(params[:city_slug])
    if (@city.present?)
      response = api.query(Prismic::Predicates.at("my.location.uid", params[:city_slug]))
      @documents = response.results.present? ? response.results[0]["location.slide_images"] : []
      @carousel_images = @city.carousel_images
      status_update_filter = @city.status_updates.where(statusable_type: 'Location')
      news_filter = @city.news_articles.where(newsable_type: "Location")
      events_filter = @city.events
      media_filter = @city.media_attachments

      if params[:search].present?
        # status_update_filter = status_update_filter.where("status_updates.title LIKE ? OR status_updates.content LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if status_update_filter.present?
        status_update_filter = status_update_filter.ransack(title_or_content_cont: params[:search]).result if status_update_filter.present?
        # news_filter.where("news_articles.title LIKE ? OR news_articles.content LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if news_filter.present?
        news_filter = news_filter.ransack(title_or_content_cont: params[:search]).result if news_filter.present?
        # events_filter = events_filter.where("events.name LIKE ? OR events.description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if events_filter.present?
        events_filter = events_filter.ransack(name_or_description_cont: params[:search]).result if events_filter.present?
        # media_filter = media_filter.where("media_attachments.title LIKE ? OR media_attachments.description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if media_filter.present?
        media_filter = media_filter.ransack(title_or_description_cont: params[:search]).result if media_filter.present?
      end

      if params[:market_id].present?
        # @vertical_market = VerticalMarket.find(params[:market_id])
        # vertical_market_ids = [@vertical_market.id]
        # vertical_market_ids += @vertical_market.children.pluck(:id) if @vertical_market.has_children?

        status_update_filter = status_update_filter.where(category_id: params[:market_id]) if status_update_filter.present?
        news_filter = news_filter.where(category_id: params[:market_id]) if news_filter.present?
        events_filter = events_filter.where(category_id: params[:market_id]) if events_filter.present?
        media_filter = media_filter.where(category_id: params[:market_id]) if media_filter.present?
      end

      @status_updates = status_update_filter.limit(PER_PAGE)
      @news = news_filter.limit(PER_PAGE)
      @events = events_filter.order(:starts_at).limit(PER_PAGE)
      @media_attachments = media_filter.order('created_at DESC').limit(PER_PAGE)
      
      @districts = @city.districts
      @cities = @city.municipality.cities
      @blog_entries = @city.blog_entries.limit(PER_PAGE)
      @products = @city.products.limit(PER_PAGE)
      @coupons = @city.coupons.limit(PER_PAGE)
      @services = @city.services.limit(PER_PAGE)
      @business_improvement_areas = @city.business_improvement_areas.unscoped.order("name ASC")
    else
      @carousel_images = []
      @status_updates = []
      @news = []
      @events = []
      @blog_entries = []
      @media_attachments = []
      @products = []
      @coupons = []
      @services = []
      @districts = []
      @cities = []
      @business_improvement_areas = []
      @documents = []
    end
    render layout: "application_v_2"
  end

  def connected_advertiser
  end

  def get_regions
    @home_province = Province.find_by_slug(params[:province_id])
    regions = @home_province&.regions&.sort_by(&:name)
    render json: regions
  end

  def get_municipalities
    @home_region = Region.find_by_slug(params[:region_id])
    municipalities = @home_region&.municipalities&.sort_by(&:name)
    render json: municipalities
  end

  def get_cities
    @home_municipality = Municipality.find_by_slug(params[:municipality_id])
    cities = @home_municipality&.cities&.select(:csdname, :slug).sort_by(&:csdname)

    respond_to do |format|
      format.json { render json: cities.as_json }
    end
  end

  def get_districts
    city = City.find_by_slug(params[:city_id])
    districts = city.districts
    municipality = city.municipality
    region = municipality.region
    province = region.province
    route = "/#{province.slug}/#{region.slug}/#{municipality.slug}"
    render json: { districts: districts, route: route }
  end

  def get_neighborhoods
    if (params[:district_id].present?)
      district = District.find_by_slug(params[:district_id])
      neighborhoods = district&.neighborhoods.select(Neighborhood.without_geom_column)
      city = district.city
      municipality = city.municipality
      region = municipality.region
      province = region.province
      route = "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}/#{district.slug}"
      render json: { neighborhoods: neighborhoods, route: route }
    else
      city = City.find_by_slug(params[:city_id])
      municipality = city.municipality
      region = municipality.region
      province = region.province
      route = "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}"
      render json: { neighborhoods: [], route: route }
    end
  end

  def get_sub_neighborhoods
    if params[:neighborhood_id].present?
      neighborhood = Neighborhood.find_by_slug(params[:neighborhood_id])
      district = neighborhood.district
      neighborhoods = district.neighborhoods
      city = district.city
      municipality = city.municipality
      region = municipality.region
      province = region.province
      sub_neighborhoods = neighborhood&.sub_neighborhoods.select(Neighborhood.without_geom_column)
      route = "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}/#{district.slug}/#{neighborhood.slug}"
      render json: { sub_neighborhoods: sub_neighborhoods, route: route }
    else
      district = District.find_by_slug(params[:district_id])
      neighborhoods = district.neighborhoods
      city = district.city
      municipality = city.municipality
      region = municipality.region
      province = region.province
      route = "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}/#{district.slug}"
      render json: { sub_neighborhoods: [], route: route }
    end
  end

  def get_sub_neighborhood
    if params[:sub_neighborhood_id].present?
      sub_neighborhood = Neighborhood.find_by_slug(params[:sub_neighborhood_id])
      neighborhood = sub_neighborhood.neighborhood
      district = neighborhood.district
      neighborhoods = district.neighborhoods
      city = district.city
      municipality = city.municipality
      region = municipality.region
      province = region.province
      route = "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}/#{district.slug}/#{neighborhood.slug}/#{sub_neighborhood.slug}"
      render json: { sub_neighborhood: sub_neighborhood.as_json_without_geom.to_json, route: route }
    else
      neighborhood = Neighborhood.find_by_slug(params[:neighborhood_id])
      district = neighborhood.district
      city = district.city
      municipality = city.municipality
      region = municipality.region
      province = region.province
      route = "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}/#{district.slug}/#{neighborhood.slug}"
      render json: { sub_neighborhood: [], route: route }
    end
  end
end
