class HomeController < ApplicationController
  layout "application_v_3"

  PER_PAGE = 20

  def index
    @countries = Country.all
    @provinces = Province.all.sort_by(&:name)
    @city = City.find(5915022)
    @carousel_images = @city.carousel_images
    @status_updates = @city.status_updates.where(statusable_type: 'Location').limit(PER_PAGE)
    @events = @city.events.order(:starts_at).limit(PER_PAGE)
    @media_attachments = @city.media_attachments.order('created_at DESC').limit(PER_PAGE)
    @districts = @city.districts
    @news = @city.news_articles.where(newsable_type: "Location").limit(PER_PAGE)
    @blog_entries = @city.blog_entries.limit(PER_PAGE)
    @products = @city.products.limit(PER_PAGE)
    @coupons = @city.coupons.limit(PER_PAGE)
    @services = @city.services.limit(PER_PAGE)
  end

  def city_landing
    # @city = City.find(5915022)
    @city = City.find_by_slug(params[:city_slug])
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
    render layout: "application_v_2"
  end

  def connected_advertiser
  end

  def get_regions
    province = Province.find_by_slug(params[:province_id])
    regions = province&.regions
    render json: regions
  end

  def get_municipalities
    region = Region.find_by_slug(params[:region_id])
    municipalities = region&.municipalities
    render json: municipalities
  end

  def get_cities
    municipality = Municipality.find_by_slug(params[:municipality_id])
    cities = municipality&.cities
    render json: cities
  end

  def get_neighborhoods
    district = District.find_by_slug(params[:district_id])
    neighborhoods = district&.neighborhoods
    city = district.city
    municipality = city.municipality
    region = municipality.region
    province = region.province
    route = "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}"
    render json: {neighborhoods: neighborhoods, route: route}
  end
end
