require 'net/http'
require 'open-uri'


namespace :app do

  task :import_south_granville => :environment do
    # puts "hello"
    doc = Nokogiri.XML(open('http://www.southgranville.org/shops-services-directory/full-retail-shops-listing/#connections-list-head'))

    doc.css('.vcard').each do |vcard|

      email = vcard.at_css('span.email a.value').nil? ? nil : vcard.at_css('span.email a.value').text.strip
      phone = vcard.at_css('span.tel span.value').nil? ? nil : vcard.at_css('span.tel span.value').text.strip
      website_url = vcard.at_css('a.url').nil? ? nil : vcard.at_css('a.url').attr('href')
      content = vcard.at_css('p').nil? ? nil : vcard.at_css('p').text.strip
      address = vcard.at_css('div.street-address').nil? ? nil : vcard.at_css('div.street-address').text.strip
      postal_code = vcard.at_css('span.postal-code').nil? ? nil : vcard.at_css('span.postal-code').text.strip
      logo_url = vcard.at_css('img.photo').nil? ? nil : URI.parse(URI.encode(vcard.at_css('img.photo').attr('src')))

      location = {
        name: vcard.at_css('span.org').text.strip,
        phone: phone,
        email: email,
        website_url: website_url,
        address: address,
        postal_code: postal_code,
        city_id: 5915022,
        province_id: 59,
        district_id: 65,
        country_id: 1,
        business_improvement_area_id: 1,
        content: content,
        show_phone: true,
        logo: logo_url
      }

      # puts location 
      bia_member = Location.new(location)
      bia_member.save
      puts "saved #{bia_member.name}"
    end

  end

end
