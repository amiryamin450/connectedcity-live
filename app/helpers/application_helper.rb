module ApplicationHelper
  def get_current_district
    # if @district == nil
    #   current_district = @city
    # else
    #   current_district = @district
    # end
    current_district = @municipality if @municipality
    current_district = @city if @city
    current_district = @district if @district
    current_district = @neighborhood if @neighborhood
    current_district = @sub_neighborhood if @sub_neigborhood
    current_district
  end

  def nav_item_url(item)
    if params[:sub_neighborhood_slug] || @location&.sub_neighborhood
      if params[:sub_neighborhood_slug]
        city_district_nbh_sub_guide_path(params[:city_slug], district_slug, params[:neighborhood_slug], params[:sub_neighborhood_slug], item.slug)
      else
        city_district_nbh_sub_guide_path(@location&.city&.slug, @location&.district&.slug, @location&.neighborhood&.slug, @location&.sub_neighborhood&.slug, item.slug)
      end
    elsif params[:neighborhood_slug] || @location&.neighborhood
      if params[:neighborhood_slug]
        city_district_neighborhood_guide_path(params[:city_slug], @district_slug, params[:neighborhood_slug], item.slug)
      else
        city_district_neighborhood_guide_path(@location&.city&.slug, @location&.district&.slug, @location&.neighborhood&.slug, item.slug)
      end
    elsif @district_slug || @location&.district
      if @district_slug
        city_district_guide_path(params[:city_slug], @district_slug, item.slug)
      else
        city_district_guide_path(@location&.city&.slug, @location&.district&.slug, item.slug)
      end
    elsif params[:city_slug] || @location&.city
      city_guide_path(params[:city_slug] || @location&.city&.slug, item.slug)
    elsif params[:municipality_slug] || @location&.municipality
      municipality_guide_path(params[:municipality_slug] || @location&.municipality&.slug, item.slug)
    else
      '#'
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
      '#'
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
end
