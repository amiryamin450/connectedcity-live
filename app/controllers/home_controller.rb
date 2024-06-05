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
      blog_entries_filter = @city.blog_entries
      products_filter = @city.products
      coupons_filter = @city.coupons
      services_filter = @city.services

      if params[:search].present?
        # status_update_filter = status_update_filter.where("status_updates.title LIKE ? OR status_updates.content LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if status_update_filter.present?
        status_update_filter = status_update_filter.ransack(title_or_content_cont: params[:search]).result if status_update_filter.present?
        # news_filter.where("news_articles.title LIKE ? OR news_articles.content LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if news_filter.present?
        news_filter = news_filter.ransack(title_or_content_cont: params[:search]).result if news_filter.present?
        # events_filter = events_filter.where("events.name LIKE ? OR events.description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if events_filter.present?
        events_filter = events_filter.ransack(name_or_description_cont: params[:search]).result if events_filter.present?
        # media_filter = media_filter.where("media_attachments.title LIKE ? OR media_attachments.description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if media_filter.present?
        media_filter = media_filter.ransack(title_or_description_cont: params[:search]).result if media_filter.present?

        blog_entries_filter = blog_entries_filter.ransack(title_or_content_cont: params[:search]).result if blog_entries_filter.present?

        products_filter = products_filter.ransack(name_or_sku_or_description_cont: params[:search]).result if products_filter.present?

        coupons_filter = coupons_filter.ransack(name_or_description_cont: params[:search]).result if coupons_filter.present?

        services_filter = services_filter.ransack(name_or_description_cont: params[:search]).result if services_filter.present?
      end

      if params[:market_id].present?
        vertical_market = VerticalMarket.find(params[:market_id])
        # vertical_market_ids = [@vertical_market.id]
        # vertical_market_ids += @vertical_market.children.pluck(:id) if @vertical_market.has_children?

        status_update_ids = vertical_market.get_status_updates(@city.municipality, @city, nil, nil, nil, true).map(&:id)
        status_update_filter = status_update_filter.where(id: status_update_ids) if status_update_filter.present?

        new_ids = vertical_market.get_news_articles_municipality(@city.municipality, @city).map(&:id)
        news_filter = news_filter.where(id: new_ids) if news_filter.present?

        event_ids = vertical_market.get_events_municipality(@city.municipality, @city).map(&:id)
        events_filter = events_filter.where(id: event_ids) if events_filter.present?

        media_ids = vertical_market.get_media_attachments_municipality(@city.municipality, @city).map(&:id)
        media_filter = media_filter.where(id: media_ids) if media_filter.present?

        blog_entry_ids = vertical_market.get_blog_entries(@city.municipality, @city).map(&:id)
        blog_entries_filter = blog_entries_filter.where(id: blog_entry_ids) if blog_entries_filter.present?

        product_ids = vertical_market.get_products(@city.municipality, @city).map(&:id)
        products_filter = products_filter.where(id: product_ids) if products_filter.present?

        coupon_ids = vertical_market.get_coupons(@city.municipality, @city).map(&:id)
        coupons_filter = coupons_filter.where(id: coupon_ids) if coupons_filter.present?

        service_ids = vertical_market.get_services(@city.municipality, @city).map(&:id)
        services_filter = services_filter.where(id: service_ids) if services_filter.present?
      end

      @districts = @city.districts
      @cities = @city.municipality.cities

      @status_updates = apply_order(status_update_filter).limit(PER_PAGE)
      @news = apply_order(news_filter).limit(PER_PAGE)
      @events = apply_order(events_filter, direction: "desc", column: "starts_at").limit(PER_PAGE)
      @media_attachments = apply_order(media_filter).limit(PER_PAGE)
      @blog_entries = apply_order(blog_entries_filter).limit(PER_PAGE)
      @products = apply_order(products_filter).limit(PER_PAGE)
      @coupons = apply_order(coupons_filter).limit(PER_PAGE)
      @services = apply_order(services_filter).limit(PER_PAGE)
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
