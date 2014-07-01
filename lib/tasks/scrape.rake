require 'nokogiri'
require 'mechanize'

task :scrape => :environment do





  agent = Mechanize.new
  agent.user_agent_alias = 'Mac Safari'

  District.all.each do |district|

    VerticalMarketCategory.all.each do |vmc|

      puts "#{vmc.name} - #{district.name}, #{district.city.name}, #{district.city.province.abbr}"

      log_prefix = "#{district.name} - #{vmc.name}: "
      agent.get('http://www.yellowpages.com/')

      search_form = agent.page.forms.first
      search_form.search_terms = vmc.name
      search_form.geo_location_terms = "#{district.name}, #{district.city.name}, #{district.city.province.abbr}"
      search_form.submit


      puts "... processing ... "

      while not agent.page.link_with(:text => 'Next').nil? do


          listings = agent.page.search('.listing_content')

          puts "Number of Listings: #{listings.size}"

          listings.each do |listing|

            yp_lid = listing.at('h3.business-name').attributes['data-lid'] unless listing.at('h3.business-name').nil?






            yp_categories = []
            unless listing.at('.business-categories').nil?
              listing.search('.business-categories li').each do |category|
                yp_categories << category.at('a').text.strip
              end
            end

            yp_neighborhoods = []
            unless listing.at('.neighborhoods').nil?
              listing.search('.neighborhoods li').each do |neighborhood|
                yp_neighborhoods << neighborhood.at('a').text.strip
              end
            end



    # puts "--------------------------------------------------------------------------------------------------------------"
    # puts "Name: #{name}"
    # puts "Yellow Pages ID: #{yp_lid}"
    # puts "Adress: #{address} #{city}, #{province} #{postal_code}"
    # puts "Phone: #{phone} "
    # puts "URL: #{website_url.nil? ? '** none **' : website_url}"
    # puts "GeoCoords: (#{latitude}, #{longitude})"
    # puts "Vertical Market: #{vertical_market}"
    # puts "Category: #{vertical_market_category}"
    # puts "YellowPages Categories: #{yp_categories.join(", ")}"
    # puts "YellowPages Neighborhoods: #{yp_neighborhoods.join(", ")}"


            
            # check to see if a location exists
            puts "YP ID: #{yp_lid}"
            if Location.exists?(:yp_lid => yp_lid)
              puts "skipping"
              location = Location.find_by_yp_lid(yp_lid)
              location.tag_categories = (location.tag_categories.split(',') | yp_categories).join(',')
              location.tag_neighborhoods = (location.tag_neighborhoods.split(',') | yp_neighborhoods).join(',')
              location.vertical_market_categories << vmc #unless location.vertical_market_categories.exists?(:vertical_market_category_id => vmc.id)
              location.save

              puts "#{log_prefix} Updated #{location.name}"

            else
              puts "Starting scrape"
              name = listing.at('h3.business-name a').text.strip unless listing.at('h3.business-name a').nil?
              address = listing.at('.street-address').text.strip.chomp unless listing.at('.street-address').nil?
              city = listing.at('.locality').text.strip unless listing.at('.locality').nil?
              province = listing.at('.region').text.strip unless listing.at('.region').nil?
              postal_code = listing.at('.postal-code').text.strip unless listing.at('.postal-code').nil?
              phone = listing.at('.business-phone').text.strip unless listing.at('.business-phone').nil?

              website_url = listing.at('.website-feature a').attributes['href'] unless listing.at('.website-feature a').nil?

              latitude = listing.at('.latitude').text.strip unless listing.at('.latitude').nil?
              longitude = listing.at('.longitude').text.strip unless listing.at('.longitude').nil?

              unless name.nil? or address.nil? or city.nil? or province.nil? or postal_code.nil?

                sys_province = Province.find_by_abbr(province)

                location = {
                  :name => name,
                  :address => address,
                  :city => sys_province.cities.find_by_name(city),
                  :province => sys_province,
                  :country_id => sys_province.country_id,
                  :postal_code => postal_code,
                  :phone => phone,
                  :website_url => website_url,
                  :latitude => latitude,
                  :longitude => longitude,
                  :imported => true,
                  :show_phone => true,
                  :show_toll_free => true,
                  :vertical_market_categories => [vmc],
                  :district_id => district.id,
                  :yp_lid => yp_lid,
                  :yp_categories => yp_categories.join(','),
                  :yp_neighborhoods => yp_neighborhoods.join(',')
                }

                location.save

                puts "#{log_prefix} Saved #{location[:name]}"
              else
                puts "#{log_prefix} Skipped saving #{location[:name]} [was not in valid format]"
              end
            end
          end
          agent.page.link_with(:text => 'Next').click
        end
      end
    end


    #
    # agent.get('http://www.yellowpages.com/')

    # search_form = agent.page.forms.first
    # search_form.search_terms = vertical_market_category
    # search_form.geo_location_terms = "Plano, TX"
    # search_form.submit








    # count += 1

    # puts ""
    # puts ""
    # puts ""
    # puts ""
    # puts "============================= DONE ============================="
    # puts ""
    # puts "               TOTAL Processed #{count} Items"
    # puts ""
    # puts "================================================================"
    # puts ""
    # puts ""
    # puts ""
    # puts ""



  end
