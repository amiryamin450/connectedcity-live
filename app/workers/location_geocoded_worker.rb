class LocationGeocodedWorker
  include Sidekiq::Worker

  def perform(offset=0, limit=1000)
    Location.transaction do
      locations = Location.limit(limit).offset(offset).includes(:province, neighborhood: :city).where('latitude IS NULL AND longitude IS NULL') do |l|
        l.geocode
        l.save
      end
    end
  end
end