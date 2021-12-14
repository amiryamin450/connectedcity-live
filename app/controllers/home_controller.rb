class HomeController < ApplicationController
  layout "global_home"

  PER_PAGE = 20

  def index
    @city = City.find(5915022)
    @carousel_images = @city.carousel_images
    @status_updates = @city.status_updates.where(statusable_type: 'Location').limit(PER_PAGE)
    @events = @city.events.order(:starts_at).limit(PER_PAGE)
    @media_attachments = @city.media_attachments.order('created_at DESC').limit(PER_PAGE)
    @districts = @city.districts
    @news = @city.news_articles.where(newsable_type: "Location").limit(PER_PAGE)
    @blog_entries = @city.blog_entries.limit(PER_PAGE)
    @products = @city.products.limit(PER_PAGE)
    @coupons = @city.coupons.limit(PER_PAGE)
  end

  def city_landing
    @city = City.find(5915022)
    @carousel_images = @city.carousel_images
    @status_updates = @city.status_updates.where(statusable_type: 'Location').limit(PER_PAGE)
    @news = @city.news_articles.where(newsable_type: "Location").limit(PER_PAGE)
    @events = @city.events.order(:starts_at).limit(PER_PAGE)
    @media_attachments = @city.media_attachments.order('created_at DESC').limit(PER_PAGE)
    @districts = @city.districts
    @blog_entries = @city.blog_entries.limit(PER_PAGE)
    @products = @city.products.limit(PER_PAGE)
    @coupons = @city.coupons.limit(PER_PAGE)
    render layout: "application_v_2"
  end

  def connected_advertiser
  end
end
