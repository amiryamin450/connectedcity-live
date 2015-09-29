class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_up


  def user_has_favorite?(location_id)
    @favorites.find {|f| f['location_id'] == location_id }
  end

  helper_method :user_has_favorite?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end


  protected

  def set_up

    @vertical_markets_all = VerticalMarket.order(:name).at_depth 0
    user_signed_in? ? @favorites = current_user.favorites.all : @favorites = []

    @city = City.find(5915022)
    @sidebar_class = if cookies[:sidebar_class].present?
                        cookies[:sidebar_class]
                      else
                        'menu-min'
                      end

    if request.fullpath == "/"
      cookies.delete(:base_path)
      cookies.delete(:district_route)
    end

    @base_path = if params[:district_route].present? and params[:neighborhood].present?
                    cookies[:base_path] = "/#{params[:district_route]}/#{params[:neighborhood]}/"
                    cookies[:district_route] = params[:district_route]
                    @district = District.find(params[:district_route])
                    @neighborhood = Neighborhood.find(params[:neighborhood])
                    "/#{params[:district_route]}/#{params[:neighborhood]}/"
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


  private

  def set_region

  end

  def set_subregion
    # if params[:sub_region].present?
    #   @sub_region = @region.sub_regions.find(params[:sub_region])
    #   @page_title_part = @sub_region.name
    #   add_crumb @sub_region.name, subregion_guide_path(@sub_region)
    # end
  end

  def set_city
    # if params[:city].present?
    #   @city = @sub_region.cities.find(params[:city])
    #   @page_title_part = @city.name
    #   add_crumb @city.name, city_guide_path(@sub_region, @city)
    # end
  end

  def set_district
    # if params[:district_route].present?
    #   @district = District.find(params[:district_route])
    #   @page_title_part = @district.name
    #   add_crumb @district.name, district_path(@district)
    # end
  end

  def set_neighborhood
    if params[:neighborhood].present?
      @neighborhood = Neighborhood.find(params[:neighborhood])
      add_crumb @neighborhood.name, '#'
    end
  end

  def set_location_dependent_crumbs
    @vertical_market = @location.vertical_market_categories.first.vertical_market
    add_crumb '<i class="icon-home"></i> Home'.html_safe, @base_path
    add_crumb @vertical_market.name, "#{@base_path}guide/#{@vertical_market.slug}"
    # add_crumb @location.vertical_market_categories.first.name, "#{@base_path}category/#{@location.vertical_market_categories.first.slug}"
    add_crumb @location.broker.name, "#{@base_path}business/#{@location.broker.slug}" if @location.broker.present?
    add_crumb @location.name, location_path(@location)
  end

end
