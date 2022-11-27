class HomeController < ApplicationController
  layout "application_v_3"
  include PrismicController

  PER_PAGE = 20

  def index
    @provinces = Province.all.sort_by(&:name)
  end

  def city_landing
    @city = City.find_by_slug(params[:city_slug])
    if (@city.present?)
      response = api.query(Prismic::Predicates.at("my.location.uid", params[:city_slug]))
      @documents = response.results.present? ? response.results[0]["location.slide_images"] : []
      @carousel_images = @city.carousel_images
      @status_updates = @city.status_updates.where(statusable_type: 'Location').limit(PER_PAGE)
      @news = @city.news_articles.where(newsable_type: "Location").limit(PER_PAGE)
      @events = @city.events.order(:starts_at).limit(PER_PAGE)
      @media_attachments = @city.media_attachments.order('created_at DESC').limit(PER_PAGE)
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
    cities = @home_municipality&.cities&.sort_by(&:csdname)
    render json: cities
  end

  def get_districts
    city = City.find_by_slug(params[:city_id])
    districts = city.districts
    municipality = city.municipality
    region = municipality.region
    province = region.province
    route = "/#{province.slug}/#{region.slug}/#{municipality.slug}"
    render json: {districts: districts, route: route}
  end

  def get_neighborhoods
    if (params[:district_id].present?)
      district = District.find_by_slug(params[:district_id])
      neighborhoods = district&.neighborhoods
      city = district.city
      municipality = city.municipality
      region = municipality.region
      province = region.province
      route = "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}/#{district.slug}"
      render json: {neighborhoods: neighborhoods, route: route}
    else
      city = City.find_by_slug(params[:city_id])
      municipality = city.municipality
      region = municipality.region
      province = region.province
      route = "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}"
      render json: {neighborhoods: [], route: route}
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
      sub_neighborhoods = neighborhood&.sub_neighborhoods
      route = "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}/#{district.slug}/#{neighborhood.slug}"
      render json: {sub_neighborhoods: sub_neighborhoods, route: route}
    else
      district = District.find_by_slug(params[:district_id])
      neighborhoods = district.neighborhoods
      city = district.city
      municipality = city.municipality
      region = municipality.region
      province = region.province
      route = "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}/#{district.slug}"
      render json: {sub_neighborhoods: [], route: route}
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
      render json: {sub_neighborhood: sub_neighborhood, route: route}
    else
      neighborhood = Neighborhood.find_by_slug(params[:neighborhood_id])
      district = neighborhood.district
      city = district.city
      municipality = city.municipality
      region = municipality.region
      province = region.province
      route = "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}/#{district.slug}/#{neighborhood.slug}"
      render json: {sub_neighborhood: [], route: route}
    end
  end
end
