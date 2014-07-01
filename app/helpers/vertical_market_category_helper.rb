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

end
