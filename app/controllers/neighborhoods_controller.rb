class NeighborhoodsController < ApplicationController
  include PrismicController

  load_and_authorize_resource except:[:neighborhood_page, :sub_neighborhood_page]

  PER_PAGE = 20

  def index
    @q = Neighborhood.search(params[:q])
    @neighborhoods = @q.result(distinct: true)

  end

  def show
  end

  def edit
    @districts = @neighborhood.city.districts
  end

  def update
    if @neighborhood.update(params[:neighborhood])
      redirect_to neighborhoods_path, notice: 'The Neighborhood was updated successfully.'
    else
      render action: 'edit'
    end
  end

  def list
    if params[:district_id].present?
      neighborhoods = Neighborhood.select("nid, neighborhd").where(district_id: params[:district_id])
    else
      neighborhoods = Neighborhood.select("nid, neighborhd").where("district_id IS NOT NULL")
    end
    render json: neighborhoods
  end

  def neighborhood_page
    @district = District.find_by_slug(params[:district_slug])
    if (@district.present?)
      @neighbourhoods = @district.neighborhoods
      @neighborhood = @neighbourhoods.find { |nbh| nbh.slug == params[:neighborhood_slug] }
      response = api.query(Prismic::Predicates.at("my.location.uid", key_neighborhood_prismic))
      @documents = response.results.present? ? response.results[0]["location.slide_images"] : []
      @city = @district.city
      @municipality = @city.municipality
      @cities = @city.municipality.cities
      @districts = @city.districts
      @sub_neighborhoods = Neighborhood.where(neighborhood_id: @neighborhood.nid)

      @status_updates = @neighborhood.status_updates.where(statusable_type: 'Location')
      @news = @neighborhood.news_articles.where(newsable_type: "Location")
      @events = @neighborhood.events
      @media_attachments = @neighborhood.media_attachments
      @blog_entries = @neighborhood.blog_entries
      @products = @neighborhood.products
      @coupons = @neighborhood.coupons
      @services = @neighborhood.services

      if params[:search].present?
        search_community
      end

      if params[:market_id].present?
        filter_community
      end

      @media_attachments = apply_order(@media_attachments).limit(PER_PAGE)
      @blog_entries = apply_order(@blog_entries).limit(PER_PAGE)
      @products = apply_order(@products).limit(PER_PAGE)
      @coupons = apply_order(@coupons).limit(PER_PAGE)
      @services = apply_order(@services).limit(PER_PAGE)
      @status_updates = apply_order(@status_updates).limit(PER_PAGE)
      @news = apply_order(@news).limit(PER_PAGE)
      @events = apply_order(@events, direction: "desc", column: "starts_at").limit(PER_PAGE)
      @business_improvement_areas = @city.business_improvement_areas.unscoped.order("name ASC")
      @business_improvement_area = @business_improvement_areas.first
    end

    respond_to do |format|
      format.html { render layout: "application_v_2" }
    end
  end

  def sub_neighborhood_page
    @neighborhood = Neighborhood.find_by_slug(params[:neighborhood_slug])

    if (@neighborhood.present?)
      response = api.query(Prismic::Predicates.at("my.location.uid", key_sub_neighborhood_prismic))
      @documents = response.results.present? ? response.results[0]["location.slide_images"] : []
      @district = @neighborhood.district
      @neighbourhoods = @district.neighborhoods
      @city = @district.city
      @municipality = @city.municipality
      @cities = @city.municipality.cities
      @districts = @city.districts
      @sub_neighborhoods = Neighborhood.where(neighborhood_id: @neighborhood.nid)
      @sub_neighborhood = @sub_neighborhoods.find{|sub| sub.slug == params[:sub_neighborhood_slug]}

      @status_updates = @sub_neighborhood.status_updates.where(statusable_type: 'Location')
      @news = @sub_neighborhood.news_articles.where(newsable_type: "Location")
      @events = @sub_neighborhood.events
      @media_attachments = @sub_neighborhood.media_attachments
      @blog_entries = @sub_neighborhood.blog_entries
      @products = @sub_neighborhood.products
      @coupons = @sub_neighborhood.coupons
      @services = @sub_neighborhood.services

      if params[:search].present?
        search_community
      end

      if params[:market_id].present?
        filter_community
      end

      @media_attachments = apply_order(@media_attachments).limit(PER_PAGE)
      @blog_entries = apply_order(@blog_entries).limit(PER_PAGE)
      @products = apply_order(@products).limit(PER_PAGE)
      @coupons = apply_order(@coupons).limit(PER_PAGE)
      @services = apply_order(@services).limit(PER_PAGE)
      @status_updates = apply_order(@status_updates).limit(PER_PAGE)
      @news = apply_order(@news).limit(PER_PAGE)
      @events = apply_order(@events, direction: "desc", column: "starts_at").limit(PER_PAGE)
      @business_improvement_areas = @city.business_improvement_areas.unscoped.order("name ASC")
      @business_improvement_area = @business_improvement_areas.first
    end

    respond_to do |format|
      format.html { render layout: "application_v_2" }
    end
  end

  private

  def key_neighborhood_prismic
    "#{params[:city_slug]}-#{params[:district_slug]}-#{params[:neighborhood_slug]}"
  end

  def key_sub_neighborhood_prismic
    "#{key_neighborhood_prismic}-#{params[:sub_neighborhood_slug]}"
  end

end
