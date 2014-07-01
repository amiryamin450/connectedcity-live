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
    @vertical_markets_all = VerticalMarket.at_depth 0
    user_signed_in? ? @favorites = current_user.favorites.all : @favorites = []


    @base_path = if params[:sub_region].present? && params[:city].present? && params[:district].present?
                    "/region/#{params[:sub_region]}/#{params[:city]}/#{params[:district]}/"
                  elsif params[:sub_region].present? && params[:city].present?
                    "/region/#{params[:sub_region]}/#{params[:city]}/"
                  elsif params[:sub_region].present?
                    "/region/#{params[:sub_region]}/"
                  else
                    root_path
                  end

    #TODO add some caching here
    #@regions_us ||= Region.find(:all, :include => [:provinces, :sub_regions => {:cities => :districts}], :conditions => ['provinces.country_code = "US" and regions.show_in_menu = 1'])

    @regions_us ||= Region.includes( [:provinces, :sub_regions => { :cities => :districts } ]).where('provinces.country_code = "US" and regions.show_in_menu = 1')
    @regions_ca ||= Region.includes( [:provinces, :sub_regions => { :cities => :districts } ]).where('provinces.country_code = "CA" and regions.show_in_menu = 1')

    #@regions_ca ||= Region.find(:all, :include => [:provinces, :sub_regions => {:cities => :districts}], :conditions => ['provinces.country_code = "CA" and regions.show_in_menu = 1'])
    # Region.includes(:sub_regions => {:cities => :districts}).where(:show_in_menu => true)
    @path_metro = request.subdomain.present? ? request.subdomain : nil
    @path_sub_region = params[:sub_region].present? ? params[:sub_region] : nil
    @path_city = params[:city].present? ? params[:city] : nil
    @path_district = params[:district].present? ? params[:district] : nil


  end


  private

  def set_region
    if request.subdomain.present? && request.subdomain != 'www'
      @region = Region.find_by_subdomain(request.subdomain)
      @page_title_part = @region.name
      add_crumb @region.name, '/'
    end
  end

  def set_subregion
    if params[:sub_region].present?
      @sub_region = @region.sub_regions.find(params[:sub_region])
      @page_title_part = @sub_region.name
      add_crumb @sub_region.name, subregion_guide_path(@sub_region)
    end
  end

  def set_city
    if params[:city].present?
      @city = @sub_region.cities.find(params[:city])
      @page_title_part = @city.name
      add_crumb @city.name, city_guide_path(@sub_region, @city)
    end
  end

  def set_district
    if params[:district].present?
      @district = District.find(params[:district])
      @page_title_part = @district.name
      add_crumb @district.name, district_guide_path(@sub_region, @city, @district)
    end
  end

end
