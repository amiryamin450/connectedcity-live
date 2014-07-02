require 'csv'


namespace :neighborhoods do 
  task :set_all => :environment do
    Location.geocoded.each do |location|
      unless location.latitude.nil?
        puts "processing #{location.name}"
        location.neighborhood = Neighborhood.calculate(location.longitude, location.latitude, 'N')
        location.save
      end
    end
  end
end

