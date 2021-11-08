class HomeController < ApplicationController
  layout "application_v_2"

  PER_PAGE = 20

  def index
    @city = City.find(5915022)
    @carousel_images = @city.carousel_images
    @status_updates = @city.status_updates.where(statusable_type: 'Location').limit(PER_PAGE)
    @events = @city.events.order(:starts_at).limit(PER_PAGE)
    @media_attachments = @city.media_attachments.order('created_at DESC').limit(PER_PAGE)
    @districts = @city.districts
  end

  def connected_advertiser
  end
end
