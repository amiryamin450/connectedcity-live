class LocationCategoryFixWorker
  include Sidekiq::Worker

  def perform(id)
    location = Location.find(id)
    tmp = location.vertical_market_category_ids.uniq
    location.vertical_market_categories.clear
    location.vertical_market_category_ids = tmp
    puts "Saving: #{location.name} -- #{location.vertical_market_category_ids}"

  end

end