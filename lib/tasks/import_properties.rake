require 'net/http'
require 'open-uri'


namespace :app do

  task :import_concert_properties => :environment do
    id = nil
    location = Location.find('concert-properties')

    doc = Nokogiri::XML(File.open "#{Rails.root}/public/import/concert.xml") do |config|
      config.strict
    end

    doc.css("property").each do |prop|

      city = City.unscoped.find_by_csdname(get_value(prop, 'city'))
      if city
        puts city.name
        attrs = {
          name: get_value(prop, 'name'),
          address_1: get_value(prop, 'address_1'),
          address_2: get_value(prop, 'address_2'),
          city_id: city.id,
          province_id: city.province.id,
          postal_code: get_value(prop, 'postal_code'),
          phone: get_value(prop, 'phone'),
          fax: get_value(prop, 'fax'),
          email: get_value(prop, 'email'),
          tag_line: get_value(prop, 'tag_line'),
          description: get_value(prop, 'property_description'),
          website_url: get_value(prop, 'website_url'),
          facebook_url: get_value(prop, 'facebook_url'),
          neighborhood_description: get_value(prop, 'neighborhood_description'),
          property_features: prop.at_css('property_features').children.map { |c| c.text.strip unless c.blank? }.compact,
          cover_photo: URI.parse(URI.encode(prop.at_css('images').children.map { |c| c.text.strip unless c.blank? }.compact.first))
        }

        property = location.rental_properties.new(attrs)
        property.save

        puts "saved #{property.name}"
      else
        puts "lookup for #{get_value(prop, 'city')} failed."
      end
    end

  end


  task :import_fs_properties => :environment do
    id = nil
    location = Location.find('firstservice-residential')

    doc = Nokogiri::XML(File.open "#{Rails.root}/public/import/first_service.xml") do |config|
      config.strict
    end

    doc.css("property").each do |prop|

      city = City.unscoped.find_by_csdname(get_value(prop, 'city'))
      if city
        url = prop.at_css('images').children.map { |c| c.text.strip unless c.blank? }.compact.first
        uri = URI.parse(URI.encode(url)) if url
        puts city.name
        attrs = {
          name: get_value(prop, 'name'),
          address_1: get_value(prop, 'address_1'),
          address_2: get_value(prop, 'address_2'),
          city_id: city.id,
          province_id: city.province.id,
          postal_code: get_value(prop, 'postal_code'),
          phone: get_value(prop, 'phone'),
          fax: get_value(prop, 'fax'),
          email: get_value(prop, 'email'),
          tag_line: get_value(prop, 'tag_line'),
          description: get_value(prop, 'property_description'),
          website_url: get_value(prop, 'website_url'),
          facebook_url: get_value(prop, 'facebook_url'),
          neighborhood_description: get_value(prop, 'neighborhood_description'),
          property_features: prop.at_css('property_features').children.map { |c| c.text.strip unless c.blank? }.compact,
          cover_photo: uri
        }

        property = location.rental_properties.new(attrs)
        property.save

        puts "saved #{property.name}"
      else
        puts "lookup for #{get_value(prop, 'city')} failed."
      end
    end

  end

  def get_value(prop, ele_name)
    prop.at_css(ele_name).text.strip
  end


end
