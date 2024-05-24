class DistrictsController < ApplicationController
  include PrismicController

  load_and_authorize_resource :district, find_by: :slug, except: :homepage

  PER_PAGE = 20

  def index

  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @district = District.new(district_params)
    if @district.save
      redirect_to districts_path, notice: 'The District was created successfully.'
    else
      render action: 'new'
    end
  end

  def update
    if @district.update(district_params)
      redirect_to districts_path, notice: 'The District was updated successfully.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @district.destroy
    redirect_to districts_path, notice: 'The District was deleted successfully.'
  end

  # FIXME Why is this homepage and not show?
  def homepage
    if !request.fullpath.include? "sitemap.xml"
      response = api.query(Prismic::Predicates.at("my.location.uid", key_district_prismic))
      @documents = response.results.present? ? response.results[0]["location.slide_images"] : []
      @district = District.find_by_slug(params[:district_route])
      @city = @district.city
      @cities = @city.municipality.cities
      @districts = @city.districts
      @neighborhoods = @district.neighborhoods
      @status_updates = @district.status_updates.where(statusable_type: 'Location').limit(PER_PAGE).order('created_at DESC')
      @events = @district.events.order(:starts_at).limit(PER_PAGE)
      @media_attachments = @district.media_attachments.order('created_at DESC').limit(PER_PAGE)
      @news = @district.news_articles.limit(PER_PAGE).order('created_at DESC')
      @blog_entries = @district.blog_entries.limit(PER_PAGE).order('created_at DESC')
      @products = @district.products.limit(PER_PAGE).order('created_at DESC')
      @coupons = @district.coupons.limit(PER_PAGE).order('created_at DESC')
      add_breadcrumb '<i class="icon-home"></i> Home'.html_safe, root_path
      add_breadcrumb @district.name
    else
        send_file("#{Rails.root}/public/sitemap.xml", filename: "sitemap.xml", type: "application/xml")
    end
    render layout: "application_v_2"
  end

  private

  def key_district_prismic
    "#{params[:city_slug]}-#{params[:district_route]}"
  end

  def district_params
    params.require(:district).permit(:city_id, :description, :name, :slug, :city, :home_page_image, :use_carousel)
  end
end
