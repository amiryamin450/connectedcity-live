class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :set_up

  def user_has_favorite?(location_id)
    @favorites.find {|f| f['location_id'] == location_id }
  end

  helper_method :user_has_favorite?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  protected

  def authenticate_user
    if user_signed_in?
      authenticate_user!
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path }
        format.json
      end
    end
  end

  def set_up
    @favorites = []
    if user_signed_in?
      @favorites = current_user.favorites.all
      if current_user.cart_id.nil?
        c = Cart.create()
        c.user_id = current_user.id
        c.save
        current_user.cart_id = c.id
        current_user.save
        @cart = c
      else
        @cart = current_user.cart
      end
    end

    init_category_values

    @city = params[:city_slug] ? City.find_by_slug(params[:city_slug]) : City.find(5915022)
    @city = City.find(5915022) unless @city
    @sidebar_class = if cookies[:sidebar_class].present?
                        cookies[:sidebar_class]
                      else
                        'menu-min'
                      end

    if request.fullpath == "/"
      cookies.delete(:base_path)
      cookies.delete(:district_route)
    end
    if params[:city_slug]
      if request.fullpath == "/#{params[:city_slug]}"
        cookies.delete(:base_path)
        cookies.delete(:district_route)
      end
    end

    #TODO: This needs to be cleaned up as it is far too complex
    #the line below previously had: !request.fullpath.include? "guide"
    #this was causing the navigation for listings at the neighbourhood level to break
    # - Don Marges, March 22, 2017
    @base_path = if params[:district_route].present? and params[:neighborhood].present? and request.fullpath.include? "guide"
                    cookies[:base_path] = "/#{params[:district_route]}/#{params[:neighborhood]}/"
                    cookies[:district_route] = params[:district_route]
                    @district = District.find(params[:district_route])
                    @neighborhood = Neighborhood.find(params[:neighborhood])
                    "/#{params[:district_route]}/#{params[:neighborhood]}/"
                  elsif request.fullpath.include? "sitemap.xml"
                    
                  elsif params[:district_route].present?
                    cookies[:base_path] = "/#{params[:district_route]}/#{params[:neighborhood]}/"
                    cookies[:district_route] = params[:district_route]
                    @district = District.find(params[:district_route])
                    cookies[:base_path] = "/#{params[:district_route]}/"
                    "/#{params[:district_route]}/"
                  elsif cookies[:base_path].present? and params['action'] != 'guide'
                    @district = District.find(cookies[:district_route])
                    cookies[:base_path]
                  else
                    cookies.delete(:base_path)
                    cookies.delete(:district_route)
                    root_path
                  end

  end

  def init_category_values
    category_news
    @results = VerticalMarket.order(:name).at_depth 0
    @vertical_market_news = @results.select{|i| i.slug === 'civic-news'}.first
    @vertical_market_members = @results.select{|i| i.slug === 'members'}.first
    @vertical_markets_all = @results.reject{|i| ['civic-news', 'employment-opportunities', 'classifieds', 'members'].include?(i.slug)}
  end

  private

  def set_region

  end

  def set_subregion
    # if params[:sub_region].present?
    #   @sub_region = @region.sub_regions.find(params[:sub_region])
    #   @page_title_part = @sub_region.name
    #   add_breadcrumb @sub_region.name, subregion_guide_path(@sub_region)    
    # end
  end

  def set_city
    # if params[:city].present?
    #   @city = @sub_region.cities.find(params[:city])
    #   @page_title_part = @city.name
    #   add_breadcrumb @city.name, city_guide_path(@sub_region, @city)
    # end
  end

  def set_district
    # if params[:district_route].present?
    #   @district = District.find(params[:district_route])
    #   @page_title_part = @district.name
    #   add_breadcrumb @district.name, district_path(@district)
    # end
  end

  def set_neighborhood
    if params[:neighborhood].present?
      @neighborhood = Neighborhood.find(params[:neighborhood])
    end
  end

  def set_bia
    if params[:business_improment_area_id].present?
      @bia = BusinessImprovementArea.find params[:business_improment_area_id]
    end
  end

  def set_location_dependent_vertical_market_crumbs
    @vertical_market = @location.vertical_market_categories.first.vertical_market
    add_breadcrumb '<i class="icon-home"></i> Home'.html_safe, @base_path
    add_breadcrumb @vertical_market.name, "#{@base_path}guide/#{@vertical_market.slug}"
    # add_breadcrumb @location.vertical_market_categories.first.name, "#{@base_path}category/#{@location.vertical_market_categories.first.slug}"
    add_breadcrumb @location.broker.name, "#{@base_path}business/#{@location.broker.slug}" if @location.broker.present?
    add_breadcrumb @location.name, location_path(@location)
  end

  def category_news
    names = [
      'City Council',
      'Fire & Emergency',
      'Home, Property & Development',
      'Law Enforcement',
      'Parks Recreation & Culture',
      'People & Programs',
      'Streets & Transportation'
    ]
    @categories_news = Category.where(name: names)
  end

end
