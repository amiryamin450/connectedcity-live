module ApplicationHelper

  def alert_color(type)
    case type
    when :error
      "danger"
    when :notice
      "info"
    when :alert
      "warning"
    else
      type.to_s
    end
  end

  def get_current_district
    @sub_neigborhood || @neighborhood || @district || @city || @municipality
  end

  def nav_item_url(item)
    market = item.slug == 'civic-news' ? 'news' : item.slug
    if params[:sub_neighborhood_slug] || @location&.sub_neighborhood
      if params[:sub_neighborhood_slug]
        city_district_nbh_sub_guide_path(params[:city_slug], @district_slug, params[:neighborhood_slug], params[:sub_neighborhood_slug], market)
      else
        city_district_nbh_sub_guide_path(@location&.city&.slug, @location&.district&.slug, @location&.neighborhood&.slug, @location&.sub_neighborhood&.slug, market)
      end
    elsif params[:neighborhood_slug] || @location&.neighborhood
      if params[:neighborhood_slug]
        city_district_neighborhood_guide_path(params[:city_slug], @district_slug, params[:neighborhood_slug], market)
      else
        city_district_neighborhood_guide_path(@location&.city&.slug, @location&.district&.slug, @location&.neighborhood&.slug, market)
      end
    elsif @district_slug || @location&.district
      if @district_slug
        city_district_guide_path(params[:city_slug], @district_slug, market)
      else
        city_district_guide_path(@location&.city&.slug, @location&.district&.slug, market)
      end
    elsif params[:city_slug] || @location&.city
      city_guide_path(params[:city_slug] || @location&.city&.slug, market)
    elsif params[:municipality_slug] || @location&.municipality
      municipality_guide_path(params[:municipality_slug] || @location&.municipality&.slug, market)
    else
      city_guide_path('vancouver', market)
    end
  end

  def nav_item_child_url(child, parent)
    if params[:sub_neighborhood_slug] || @location&.sub_neighborhood
      if params[:sub_neighborhood_slug]
        city_district_nbh_sub_sub_market_guide_path(params[:city_slug], @district_slug, params[:neighborhood_slug], params[:sub_neighborhood_slug], parent.slug, child.slug)
      else
        city_district_nbh_sub_sub_market_guide_path(@location&.city&.slug, @location&.district&.slug, @location&.neighborhood&.slug, @location&.sub_neighborhood&.slug, parent.slug, child.slug)
      end
    elsif params[:neighborhood_slug] || @location&.neighborhood
      if params[:neighborhood_slug]
        city_district_neighborhood_sub_market_guide_path(params[:city_slug], @district_slug, params[:neighborhood_slug], parent.slug, child.slug)
      else
        city_district_neighborhood_sub_market_guide_path(@location&.city&.slug, @location&.district&.slug, @location&.neighborhood&.slug, parent.slug, child.slug)
      end
    elsif @district_slug || @location&.district
      if @district_slug
        city_district_sub_market_guide_path(params[:city_slug], @district_slug, parent.slug, child.slug)
      else
        city_district_sub_market_guide_path(@location&.city&.slug, @location&.district&.slug, parent.slug, child.slug)
      end
    elsif params[:city_slug] || @location&.city
        city_sub_market_guide_path(params[:city_slug] || @location&.city.slug, parent.slug, child.slug)
    elsif params[:municipality_slug] || @location&.municipality
        municipality_sub_market_guide_path(params[:municipality_slug] || @location&.municipality&.slug, parent.slug, child.slug)
    else
      city_sub_market_guide_path('vancouver', parent.slug, child.slug)
    end
  end

  def search_url
    @district_slug = params[:district_slug] || params[:district_route]
    @url = if params[:sub_neighborhood_slug]
        @url = city_district_nbh_sub_search_path(params[:city_slug], @district_slug, params[:neighborhood_slug], params[:sub_neighborhood_slug])
      elsif params[:neighborhood_slug]
        @url = city_district_nbh_search_path(params[:city_slug], @district_slug, params[:neighborhood_slug])
      elsif @district_slug
        @url = city_district_search_path(params[:city_slug], @district_slug)
      elsif params[:city_slug]
        @url = city_search_path(params[:city_slug])
      elsif params[:municipality_slug]
        @url = municipality_search_path(params[:municipality_slug])
      else
        @url = "#{@base_path}search"
      end
  end

  def map_locations_data locations
    locations.map do |m|
      {
        name: m.name,
        url: m.respond_to?(:location) ? url_for([m.location, m]) : url_for(m),
        latitude: m.latitude,
        longitude: m.longitude,
        thumb: m.logo.file? ? m.logo.url(:bia_display) : nil
      }
    end.to_json
  end
end
