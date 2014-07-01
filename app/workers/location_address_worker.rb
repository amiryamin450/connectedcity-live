
class LocationAddressWorker
  include Sidekiq::Worker

  def perform(id)
      location = Location.find(id)
      location.address = location.address.chomp(',')
      puts "Saving: #{location.name} -- #{location.address}"
      location.save
  end
end