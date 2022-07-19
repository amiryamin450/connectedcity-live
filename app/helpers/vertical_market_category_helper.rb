module VerticalMarketCategoryHelper

  def get_locations_by_type(category)
    case @arg_type
      when 'country'
        category.locations_by_country(@country)
      when 'province'
        category.locations_by_province(@province)
      when 'region'
        category.locations_by_region(@region)
      when 'community'
        category.locations_by_community(@community)
    end
  end


  def get_location_image_url(location)
    if location&.logo.present?
      location&.logo.url
    elsif location&.vertical_market_categories&.any? && location&.vertical_market_categories.first&.default_logo.present?
      location&.vertical_market_categories.first&.default_logo.url
    else
       "/logos/original/missing.png"
    end
  end

end
