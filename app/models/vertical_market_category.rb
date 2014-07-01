class VerticalMarketCategory < ActiveRecord::Base
  paginates_per 15
  extend FriendlyId
  belongs_to :vertical_market

  has_and_belongs_to_many :locations

  attr_accessible :description, :name, :slug, :vertical_market_id, :default_logo, :search_term
  friendly_id :name, use: [:slugged, :history]

  has_attached_file :default_logo, :styles => {:thumb => "70x55"},
    :url => "/assets/category/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/category/:id/:style/:basename.:extension"

  validates_attachment_size :default_logo, :less_than => 5.megabytes
  validates_attachment_content_type :default_logo, :content_type => ['image/jpeg', 'image/png']

  validates_presence_of :name
  validates_presence_of :vertical_market_id, :message => 'Please Select a Vertical Market.'

  def locations_by_country(country_slug)
    country = Country.find(country_slug)
    id = self.id
    #locations.includes(:city, :province).where(:country_id => country.id).order('locations.name').limit(20)

    # results = Tire.search('locations', :filter => {"and" => [
    #                                                  {"term" => {"vertical_market_categories.id" => id }},
    #                                                  {"term" => {"country.id" => country.id }}
    #                                                ],
    #                                                "size" => 20,
    #                                                "sort" => ["id"]
    #                                                }).results
    # results.options[:per_page] = 20

    results = Location.tire.search do
      filter :term, "vertical_market_categories.id" => id
      filter :term, "country.id" => country.id
      size 20
    end


    logger.debug "****************** ID: #{id} results #{results} - size: #{results.count} **********************"

    results
  end

  def locations_by_province(province_slug)
    province = Province.find(province_slug)
    locations.includes(:city, :province).where(:province_id => province.id).order('locations.name').limit(20)
  end

  def locations_by_region(region_slug)
    region = Region.find(region_slug)
    locations.includes(:city, :province).where(:region_id => region.id).order('locations.name').limit(20)
  end

  def locations_by_community(community_slug)
    community = Community.find(community_slug)
    locations.includes(:city, :province).joins(:city).where('cities.community_id' => community.id).order('locations.name').limit(20)
  end


  def get_locations(region = nil, subregion = nil, city = nil, district = nil, options={})
    id = self.id
    

    logger.debug " ########################################  options: #{options}   "

    results = Location.tire.search do
      query do
        boolean do
          must { term "vertical_market_categories.id", id }
          must { term "region.id", region.id } unless region.nil?
          must { term "city.sub_region_id", subregion.id } unless subregion.nil?
          must { term "city.id", city.id } unless city.nil?
          must { term "district.id", district.id } unless district.nil?
        end
      end

      filter :terms, :categories => [options[:params][:category]] unless options[:params][:category].nil?
      filter :terms, :neighborhoods => [options[:params][:neighborhood]] unless options[:params][:neighborhood].nil?
      filter :terms, :brands => [options[:params][:brand]] unless options[:params][:brand].nil?

      page = (options[:page] || 1).to_i
      search_size = options[:per] || 20
      
      from (page -1) * search_size
      size search_size
      sort { by :name_sort, 'asc'}
    end
  end


end
