# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.connectedcity.com"

SitemapGenerator::Sitemap.create do

  add '/vancouver'
  add '/vancouver-downtown'
  add '/vancouver-eastside'
  add '/vancouver-westside'

  #Business Improvement Areas
  BusinessImprovementArea.find_each do |bia|
    add business_improvement_area_path(bia), :lastmod => bia.updated_at
  end

  #Businesses
  Business.find_each do |business|
    add business_path(business), :lastmod => business.updated_at

    #Business Sub-Categories
    AutomotiveListing.find_each do |listing|
      add location_automotive_listing_path(business, listing), :lastmod => listing.updated_at
    end

    #Employment Listings
    EmploymentListing.find_each do |employ_list|
      add location_employment_listing_path(business, employ_list), :lastmod => employ_list.updated_at
    end

    #News
    add '/news'

    NewsArticle.find_each do |news|
      add location_news_article_path(business, news), :lastmod => news.updated_at
    end

    #Products
    Product.find_each do |product|
      add location_product_path(business, product), :lastmod => product.updated_at
    end

    #Real Estate Listings
    RealEstateListing.find_each do |listing|
      add location_real_estate_listing_path(business, listing), :lastmod => listing.updated_at
    end

    #Services
    Service.find_each do |service|
      add location_service_path(business, service), :lastmod => service.updated_at
    end
  end

  #City News
  CityNewsArticle.find_each do |city_news|
    add city_news_article_path(city_news), :lastmod => city_news.updated_at
  end

  #City Categories
  CityNewsCategory.find_each do |city_category|
    add city_news_category_path(city_category), :lastmod => city_category.updated_at
  end

  #Classified Categories
  ClassifiedCategory.find_each do |classified_category|
    add classified_category_path(classified_category), :lastmod => classified_category.updated_at
  end

  #Classified Listings
  ClassifiedListing.find_each do |classified_listing|
    add classified_listing_path(classified_listing), :lastmod => classified_listing.updated_at
  end

  #Employment Categories
  EmploymentCategory.find_each do |employment_category|
    add employment_category_path(employment_category), :lastmod => employment_category.updated_at
  end

  #Trade Associations
  TradeAssociation.find_each do |trade_assoc|
    add trade_association_path(trade_assoc), :lastmod => trade_assoc.updated_at
  end

  #Events
  Event.find_each do |event|
    add event_path(event), :lastmod => event.updated_at
  end
end
