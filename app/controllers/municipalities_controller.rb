class MunicipalitiesController < ApplicationController
  include PrismicController

  load_and_authorize_resource except:[:get_districts, :get_neighborhoods, :get_sub_neighborhoods]

  PER_PAGE = 20

  def index
  end

  def show
  end

  def edit
  end

  def update
    
  end

  def metro_page
    @municipality = Municipality.find_by_slug(params[:municipality_slug])
    if (@municipality.present?)
      # @neighbourhoods = @district.neighborhoods
      # @neighborhood = @neighbourhoods.find { |nbh| nbh.slug == params[:neighborhood_slug] }
      @municipalities = @municipality.region.municipalities
      response = api.query(Prismic::Predicates.at("my.location.uid", key_metro_prismic))
      @documents = response.results.present? ? response.results[0]["location.slide_images"] : []
      @cities = @municipality.cities
      @districts = @municipality.districts
      @neighbourhoods = @municipality.neighborhoods
      @sub_neighborhoods = @municipality.sub_neighborhoods
      @media_attachments = @municipality.media_attachments.order('created_at DESC').limit(PER_PAGE)
      @blog_entries = @municipality.blog_entries.limit(PER_PAGE)
      @products = @municipality.products.limit(PER_PAGE)
      @coupons = @municipality.coupons.limit(PER_PAGE)
      @services = @municipality.services.limit(PER_PAGE)
      @status_updates = @municipality.status_updates.where(statusable_type: 'Location').limit(PER_PAGE)
      @news = @municipality.news_articles.limit(PER_PAGE).order(:created_at)
      @events = @municipality.events.limit(200).order(:starts_at)
    end

    respond_to do |format|
      format.html { render layout: "application_v_2" }
    end
  end


  def get_municipalities
    @home_region = Region.find_by_slug(params[:region_id])
    municipalities = @home_region&.municipalities&.sort_by(&:name)
    render json: municipalities
  end

  def get_cities
    municipality = Municipality.find_by_slug(params[:municipality_id])
    cities = municipality.cities
    region = municipality.region
    province = region.province
    route = "/#{province.slug}/#{region.slug}/#{municipality.slug}"
    render json: {cities: cities, route: route}
  end

  def get_districts
    city = City.find_by_slug(params[:city_id])
    districts = city.districts
    municipality = city.municipality
    region = municipality.region
    province = region.province
    route = "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}"
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
    if(params[:neighborhood_id])
      neighborhood = Neighborhood.find_by_slug(params[:neighborhood_id])
      district = neighborhood.district
      neighborhoods = district&.neighborhoods
      city = district.city
      municipality = city.municipality
      region = municipality.region
      province = region.province
      route = "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}/#{district.slug}/#{neighborhood.slug}"
      render json: {route: route}
    else
      district = District.find_by_slug(params[:district_id])
      neighborhoods = district&.neighborhoods
      city = district.city
      municipality = city.municipality
      region = municipality.region
      province = region.province
      route = "/#{province.slug}/#{region.slug}/#{municipality.slug}/#{city.slug}/#{district.slug}"
      render json: {route: route}
    end
  end
  private

  def key_metro_prismic
    "#{params[:province_slug]}-#{params[:region_slug]}-#{params[:municipality_slug]}"
  end

end
