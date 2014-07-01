require 'nokogiri'
require 'mechanize'

class YellowPageScraperWorker
  include Sidekiq::Worker

  def perform(vertical_market_category_id, district_id)


    begin

      vmc = VerticalMarketCategory.find(vertical_market_category_id)
      district = District.find(district_id)

      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      agent.max_history = 5

      puts "#{vmc.search_term} - #{district.name}, #{district.city.name}, #{district.city.province.abbr}"

      log_prefix = "#{district.name} - #{vmc.name}: "



      agent.get('http://www.yellowpages.com/')

      search_form = agent.page.forms.first
      search_form.search_terms = vmc.search_term
      search_form.geo_location_terms = "#{district.name}, #{district.city.name}, #{district.city.province.abbr}"
      search_form.submit


      puts "... processing ... "

      while not agent.page.link_with(:text => 'Next').nil? do


          listings = agent.page.search('.listing_content')

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


            name = listing.at('h3.business-name a').text.strip unless listing.at('h3.business-name a').nil?
            address = listing.at('.street-address').text.strip.chomp(',') unless listing.at('.street-address').nil?
            city = listing.at('.locality').text.strip unless listing.at('.locality').nil?
            province = listing.at('.region').text.strip unless listing.at('.region').nil?
            postal_code = listing.at('.postal-code').text.strip unless listing.at('.postal-code').nil?
            phone = listing.at('.business-phone').text.strip unless listing.at('.business-phone').nil?

            website_url = listing.at('.website-feature a').attributes['href'] unless listing.at('.website-feature a').nil?

            latitude = listing.at('.latitude').text.strip unless listing.at('.latitude').nil?
            longitude = listing.at('.longitude').text.strip unless listing.at('.longitude').nil?

            # check to see if a location exists
            if Location.exists?(:yp_lid => yp_lid.to_s)

              location = Location.find_by_yp_lid(yp_lid.to_s)
              location.yp_categories |= yp_categories
              location.yp_neighborhoods |= yp_neighborhoods
              location.vertical_market_categories |= [vmc] #unless location.vertical_market_categories.exists?(:vertical_market_category_id => vmc.id)
              location.save

              puts "#{log_prefix} Updated #{location.name}"

            else

              unless province.nil? or name.nil? or city.nil? or postal_code.nil? or address.nil?
                sys_province = Province.find_by_abbr(province)

                location = {
                  :name => name,
                  :address => address,
                  :city => sys_province.cities.find_by_name(city),
                  :province => sys_province,
                  :country_id => sys_province.country_id,
                  :postal_code => postal_code,
                  :phone => phone,
                  :website_url => website_url.to_s,
                  :latitude => latitude,
                  :longitude => longitude,
                  :imported => true,
                  :show_phone => true,
                  :show_toll_free => true,
                  :vertical_market_categories => [vmc],
                  :district_id => district.id,
                  :yp_lid => yp_lid.to_s,
                  :yp_categories => yp_categories.join(','),
                  :yp_neighborhoods => yp_neighborhoods.join(',')
                }

                Location.create!(location)

                puts "#{log_prefix} Saved #{location[:name]}"
              else
                puts "#{log_prefix} Skipping #{yp_lid} invalid format or missing required data"
              end
            end
          end
          sleep_time = 1+Random.rand(7)
          puts "####################################### SLEEPING FOR - #{sleep_time} seconds ################################################"
          sleep sleep_time
          begin
            agent.page.link_with(:text => 'Next').click
          rescue Mechanize::ResponseCodeError => e
            if e.response_code == "403"
              puts "####################################### SLEEPING FOR - 15 seconds and Retrying ################################################"
              sleep 15
              agent.page.link_with(:text => 'Next').click
            else
              raise
            end
          end          
        end
      rescue Mechanize::ResponseCodeError => exception
        if exception.response_code == "403"
          puts "####################################### 403 Error - Requeue ################################################" 
          raise        
        end
      end
    end # end def
  end # end class
