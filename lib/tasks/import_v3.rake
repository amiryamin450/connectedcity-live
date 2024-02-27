require 'csv'
require 'digest/md5'

task :import_provinces => :environment do
  filepath = "public/import_data/BC-Small-Communities-Hierarchy-Nov-23.csv"

  provinces = []
  begin
    CSV.foreach(filepath, :headers => true) do |row|
      provinces << row[0]
    end
  rescue => exception
    puts exception
  end

  provinces = provinces.uniq.compact.sort()

  provinces.each do |p|
    Province.create(name: p)
  end
end

task :import_regions => :environment do
  filepath = "public/import_data/BC-Small-Communities-Hierarchy-Nov-23.csv"

  begin
    CSV.foreach(filepath, :headers => true) do |row|
      region_name = row[1]&.strip
      unless Region.exists?(name: region_name)
        region = Region.new(name: region_name)
        province_name = row[0]
        region.province = Province.find_by_name(province_name)
        region.save!
        puts region
      end
    end
  rescue => exception
    puts exception
  end
end

task :import_municipalities => :environment do
  filepath = "public/import_data/BC-Small-Communities-Hierarchy-Nov-23.csv"

  begin
    CSV.foreach(filepath, :headers => true) do |row|
      mun_name = row[2]&.strip
      unless Municipality.exists?(name: mun_name)
        mun = Municipality.new(name: mun_name)
        region_name = row[1]&.strip
        mun.region = Region.find_by_name(region_name)
        mun.save!
        puts mun
      end
    end
  rescue => exception
    puts exception
  end
end

task :import_cities => :environment do
  filepath = "public/import_data/BC-Small-Communities-Hierarchy-Nov-23.csv"
  new_data = []

  CSV.foreach(filepath, :headers => true) do |row|
    new_data << { ct_name: row[3]&.strip, mun_name: row[2]&.strip}
  end

  new_data = new_data.uniq

  new_data.each do |data|
    city = City.unscoped.find_by_csdname(data[:ct_name])
    mun = Municipality.find_by_name(data[:mun_name])
    if city.present?
      city.update({is_active: true, municipality_id: mun.id}) if mun.present?
    # else
    #     city = City.new(csdname: data[:ct_name], geom: nil)
    #     city.municipality = mun
    #     city.save!
    #     puts city
    # end
    
    end
  end
end

# district (neighbourhood)
task :import_districts => :environment do
  def import_district
  filepath = "public/import_data/BC-Small-Communities-Hierarchy-Nov-23.csv"
  new_data = []

  CSV.foreach(filepath, :headers => true) do |row|
    new_data << { dt_name: row[4]&.strip, ct_name: row[3]&.strip}
  end

  new_data = new_data.compact.uniq

  new_data.each do |data|
    district = District.find_by_name(data[:dt_name])
    city = City.find_by_csdname(data[:ct_name])

    if city.present?
      unless district.present?
        district = District.create(name: data[:dt_name])
      end

      district.update_attribute(:city_id, city.id )
    end
  end
  end
end

# neighbourhood (sub-neighbourhood)
task :import_neighbourhoods => :environment do
  filepath = "public/import_data/cc_data.csv"
  new_data = []

  CSV.foreach(filepath, :headers => true) do |row|
    new_data << { nei_name: row[5]&.strip, dt_name: row[4]&.strip}
  end

  new_data = new_data.compact.uniq

  new_data.each do |data|
    neighborhood = Neighborhood.find_by_slug(data[:nei_name]&.parameterize("-"))
    district = District.find_by_name(data[:dt_name])

    if neighborhood.present?
      neighborhood.update({district_id: district.id, neighborhd: data[:nei_name]}) if district.present?
    end
  end
end
