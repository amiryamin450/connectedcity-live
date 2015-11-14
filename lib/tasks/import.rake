require 'csv'
require 'digest/md5'


task :queue_scrape_test => :environment do
  District.all.each do |district|
    VerticalMarketCategory.all.each do |vmc|
      YellowPageScraperWorker.perform_async(vmc.id,district.id)
    end
  end
end


task :fix_location_address => :environment do
  Location.select("name, id").each do |location|
    puts "Queuing location #{location.name}"
    LocationCategoryFixWorker.perform_async(location.id)
  end
end


task :import_locations, [:path] => :environment do |t, args|

  args.with_defaults(:path => "public/assets/import")

  Dir.chdir(args.path)
  Dir.glob('*.csv').each do |file|
    delete_file = true
    next if File.directory? file
    puts file
    CSV.foreach(file, :headers => false) do |row|

      next if row[4].nil?
      next if row[6].nil?
      next if row[7].nil?

      province = Province.find_by_abbr(row[6]);
      city = province.cities.find_by_name(row[5])
      # check to see if we have a category already, if not we need to create one.
      if !VerticalMarketCategory.find_by_name(row[0]).nil?
        if !District.find_by_name(row[11]).nil? and !city.nil? and !city.region.nil?
          location = {
            :name => row[2],
            :address => row[4],
            :city => city,
            :province => province,
            :country => Country.find_by_name(row[8]),
            :vertical_market_category_ids => [VerticalMarketCategory.find_by_name(row[0]).id],
            :imported => true,
            :show_phone => true,
            :show_toll_free => true,
            :postal_code => row[7],
            :phone => row[3],
            :district => District.find_by_name(row[11]),
            :yp_lid => 'csv',
          }

          Location.create!(location)
          puts "#{location[:name]} created"
        else
          puts "###################### ERROR!!!!!!!!!!!1111  ####################"
        end
      else
        puts "############ VerticalMarketCategory not found ################"
        delete_file = false
      end

    end

    File.delete file if delete_file

  end


end

task :clear_imported_csv => :environment do
  Location.where(:yp_lid => 'csv').each do |l|
    l.delete
  end
end

task :import_vm => :environment do
  filepath = "public/assets/import_data/vm.csv"
  CSV.foreach(filepath, :headers => true) do |row|
    VerticalMarket.create!(row.to_hash)
  end
end

task :import_vmc => :environment do
  filepath = "public/assets/import_data/vmc.csv"
  CSV.foreach(filepath, :headers => true) do |row|
    r = row.to_hash
    VerticalMarketCategory.create!(r)
  end
end


task :import_brands => :environment do
  filepath = "public/assets/import_data/brands.csv"
  CSV.foreach(filepath, :headers => true) do |row|
    Brand.create!(row.to_hash)
  end
end


task :import_provinces => :environment do
  filepath = "public/assets/import_data/provincecodes.csv"
  CSV.foreach(filepath, :headers => true) do |row|
    puts "row: #{row}"
    province = {
      :name => row[0],
      :province_code => row[1],
      :country_code => row[3],
      :country_name => row[4],
      :country => Country.find_by_name(row[4]),
      :abbr => row[1].gsub("#{row[3]}-","")
    }
    Province.create!(province)

    puts "created: #{province}"
  end
end

task :import_regions => :environment do
  filepath = "public/assets/import_data/metrocodes.csv"
  CSV.foreach(filepath, :headers => true) do |row|

    if Region.exists?(:region_code => row[2])
      region = Region.find_by_region_code(row[2])
      region.provinces << Province.find_by_name(row[0])
      region.save
      puts "saved #{region.name} and added #{row[0]} to provinces"
    else
      region = {
        :name => row[1],
        :region_code => row[2],
        :provinces => [Province.find_by_name(row[0])]
      }
      Region.create!(region)

      puts "created: #{region[:name]}"
    end
  end
end

task :import_cities_us => :environment do
  filepath = "public/assets/import_data/cities_us.csv"
  CSV.foreach(filepath, :headers => true) do |row|

    city = {
      :name => row[1],
      :province => Province.find_by_name(row[0]),
      :region => Region.find_by_region_code(row[4]),
      :region_code => row[4]
    }
    City.create!(city)

    puts "created: #{city[:name]}"
  end
end


task :import_cities_ca => :environment do
  filepath = "public/assets/import_data/cities_world.csv"
  CSV.foreach(filepath, :headers => true) do |row|
    if row[4] == 'CA'
      city = {
        :name => row[1],
        :province => Province.find_by_province_code(row[3]),
      }
      City.create!(city)
      puts "created: #{city[:name]}"
    else
      puts 'Skipping - Not Canada'
    end
  end
end



task :import_sub_regions => :environment do
  filepath = "public/assets/import_data/san_fran_sub_regions.csv"
  CSV.foreach(filepath, :headers => true) do |row|
    unless SubRegion.exists?(:name => row[3])
      sub_region = {
        :name => row[3],
        :region => Region.find_by_name(row[2])
      }
      SubRegion.create!(sub_region)
      puts "Created #{sub_region[:name]}"
    end
  end
end

task :import_districts => :environment do
  filepath = "public/assets/import_data/vancouver_metro.csv"
  CSV.foreach(filepath, :headers => true) do |row|
    if District.exists?(:name => row[5])
      province_id = Province.find_by_name(row[1]).id
      district = District.find_by_name(row[5])
      district.city = City.where(:name => row[4], :province_id => province_id).first
      district.save
      puts "Saved district: #{district.name}"
    else
      province_id = Province.find_by_name(row[1]).id
      district = {
        :name => row[5],
        :city => City.where(:name => row[4], :province_id => province_id).first
      }
      District.create!(district)
      puts "Created #{district[:name]}"
    end
  end
end

task :assign_sub_regions => :environment do
  filepath = "public/assets/import_data/vancouver_metro.csv"
  cities = []
  CSV.foreach(filepath, :headers => true) do |row|
    province_id = Province.find_by_name(row[1]).id

    if !cities.include?(row[4]) and City.exists?(:name => row[4], :province_id => province_id)

      city = City.where(:name => row[4], :province_id => province_id).first

      sub_region = SubRegion.find_by_name(row[3])
      if city.sub_region.nil? or city.sub_region.id != sub_region.id
        city.sub_region = sub_region
        city.save
        puts "Linked #{city.name} to the #{city.sub_region.name} sub region"
      else
        puts "Skipping #{city.name} not a new sub region"
      end
    end
    cities << row[4]
  end
end


task :fix_neighborhood => :environment do
  Location.find_each do |location|

    n = Neighborhood.unscoped.where("ST_Intersects(geom, ST_SetSRID(ST_MakePoint(#{location.longitude}, #{location.latitude}),4326))").first if location.longitude and location.latitude
    if n
      location.neighborhood = n.neighborhd
      location.save
      puts "########################  Saved - #{location.name} - #{n.neighborhd}"

    else
      puts "========================  Skipped - #{location.name} - Neighborhood not found"
    end
  end
end


task :update_locations => :environment do
  #Location.all.each do |l|
  #  vmc = ActiveRecord::Base.connection.select_one("SELECT vertical_market_category_id FROM locations_vertical_market_categories WHERE location_id = #{l.id}")
  #  l.update_attributes(vmc)
  #  puts "#{l.name} vertical_market_category: #{l.vertical_market_category_id}"
  #end

  blah = VerticalMarketCategory.where(:vertical_market_id => 4).all
  blah.each do |vmc|
    puts vmc.name
    puts "================================"

    locations = vmc.locations.where(:city_id => 2).all

    if locations.count > 0
      vmc.locations.joins(:city).where('cities.community_id' => 5).each do |l|
        puts l.name + ' ' + l.city.name
      end
    else
      puts '**** no locations found ****'
    end
    puts "--------------------------------"
  end


  puts "done"

end

  task :set_all => :envrionment do
    Location.geocoded.each do |location|
      unless location.latitude.nil?
        puts "processing #{location.name}"
        location.maponics_neighborhood = Base::Neighborhood.calculate(location.longitude, location.latitude, 'N')
        location.sub_neighborhood = Base::Neighborhood.calculate(location.longitude, location.latitude, 'S')
        location.macro_neighborhood = Base::Neighborhood.calculate(location.longitude, location.latitude, 'M')
        location.save
      end
    end
  end
