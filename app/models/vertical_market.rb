class VerticalMarket < ActiveRecord::Base

  has_ancestry :cache_depth => true, :depth_cache_column => :ancestry_depth

  has_many :vertical_market_categories
  has_many :locations,          :through => :vertical_market_categories
  has_many :status_updates,     :through => :locations, uniq: true
  has_many :products,           :through => :locations, uniq: true
  has_many :services,           :through => :locations, uniq: true
  has_many :blog_entries,       :through => :locations, uniq: true
  has_many :events,             :through => :locations, uniq: true
  has_many :news_articles,      :through => :locations, uniq: true
  has_many :media_attachments,  :through => :locations, uniq: true
  has_many :coupons,  :through => :locations, uniq: true
  has_many :automotive_listings, :through => :locations, uniq: true


  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  attr_accessible :description,
    :name,
    :slug,
    :parent_id

  attr_accessor :menu_li_class,
    :menu_link_class

  accepts_nested_attributes_for :vertical_market_categories, allow_destroy: true

  validates_presence_of :name

  def cats(city = nil, district = nil, neighbrhd = nil)
    result = VerticalMarketCategory.includes(:status_updates).where(vertical_market_id: self.subtree_ids)
    result = result.where('locations.city_id = ?', 5915022)
    result = result.where('locations.district_id = ?', district.id) if district.present?
    result = result.where('locations.neighborhood_id = ?', neighbrhd.id) if neighbrhd.present?
    result = result.map { |c| c.status_updates.present? ? c.status_updates : nil }.compact.flatten.sort_by { |obj| obj.created_at }.first(10)

  end

  def categories
    VerticalMarketCategory.where(vertical_market_id: self.subtree_ids).order("`vertical_market_categories`.`name` ASC")
  end

  def categories_new(municipality = nil, city = nil, district = nil, neighborhood = nil, sub_neighborhood = nil)
    # FIXME MySQL 5.7 needs this to work properly.
    ActiveRecord::Base.connection.execute("SET sql_mode = ''")

    VerticalMarketCategory.joins(locations: [:city]).includes(locations: [:city]).where(vertical_market_id: self.subtree_ids, locations: location_params(municipality, city, district, neighborhood, sub_neighborhood)).group("`vertical_market_categories`.`id`, `locations`.`id`").order("`vertical_market_categories`.`name` ASC, IF(`locations`.`logo_file_name` IS NULL, 0, 1) DESC, `locations`.`updated_at` DESC")
    
  end

  def get_media_attachments(municipality = nil, city = nil, district = nil, neighborhood = nil, sub_neighborhood = nil)
    MediaAttachment.joins(location: :vertical_market_categories).where(locations: location_params(municipality, city, district, neighborhood, sub_neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`media_attachments`.`created_at` DESC").limit(10)
  end

  def get_coupons(municipality = nil, city = nil, district = nil, neighborhood = nil, sub_neighborhood = nil)
    Coupon.joins(location: :vertical_market_categories).where("`coupons`.`redemptions_count` < `coupons`.`howmany`").where(locations: location_params(municipality, city, district, neighborhood, sub_neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`coupons`.`created_at` DESC").limit 10
  end

  def get_status_updates(municipality = nil, city = nil, district = nil, neighborhood = nil, sub_neighborhood = nil, add_subtrees = true, vertical_market_category = nil)
    status_updates = StatusUpdate.joins(location: :vertical_market_categories).where(locations: location_params(municipality, city, district, neighborhood, sub_neighborhood))

    if add_subtrees
      status_updates = status_updates.where(vertical_market_categories: { vertical_market_id: self.subtree_ids })
    elsif vertical_market_category
      status_updates = status_updates.where(vertical_market_categories: { id: vertical_market_category.id })
    end

    status_updates = status_updates.order("`status_updates`.`created_at` DESC").limit 200

    if [17, 18, 19, 20].include? self.id
      status_updates += StatusUpdate.where(statusable_type: ["RealEstateListing", "NewHomeCommunity", "RentalProperty"], vertical_markets: self.subtree_ids).where(location_params(municipality, city, district, neighborhood)).order("`status_updates`.`created_at` DESC").limit 10
      status_updates = status_updates.sort_by(&:created_at).last(10).reverse
    end

    status_updates
  end

  def get_products(municipality = nil, city = nil, district = nil, neighborhood = nil, sub_neighborhood= nil)
    products = Product.joins(location: :vertical_market_categories).where(locations: location_params(municipality, city, district, neighborhood, sub_neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`products`.`created_at` DESC").limit 10
    products += Service.joins(location: :vertical_market_categories).where(locations: location_params(municipality, city, district, neighborhood, sub_neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`services`.`created_at` DESC").limit 10
    products.sort_by(&:created_at).last(10).reverse
  end

  def get_blog_entries(municipality = nil, city = nil, district = nil, neighborhood = nil, sub_neighborhood = nil)
    BlogEntry.joins(location: :vertical_market_categories).where(locations: location_params(municipality, city, district, neighborhood, sub_neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`blog_entries`.`created_at` DESC").uniq.limit 10
  end

  def get_events(municipality = nil, city = nil, district = nil, neighborhood = nil, sub_neighborhood = nil)
    Event.joins(location: :vertical_market_categories).where("`events`.`ends_at` > CURRENT_TIMESTAMP").where(locations: location_params(municipality, city, district, neighborhood, sub_neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`events`.`created_at` DESC").limit 10
  end

  def get_news_articles(municipality = nil, city = nil, district = nil, neighborhood = nil, sub_neighborhood = nil)
    NewsArticle.joins(location: :vertical_market_categories).where(locations: location_params(municipality, city, district, neighborhood, sub_neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`news_articles`.`created_at` DESC").limit 10
  end

  def location_params(municipality = nil, city = nil, district = nil, neighborhood = nil, sub_neighborhood = nil)
    if municipality.present?
      location_params = {municipality_id: municipality.id}
    elsif city.present?
      location_params = {city_id: city.id}
      if district.present?
        location_params = {district_id: district.id}
      end
      if neighborhood.present?
        location_params = {neighborhood_id: neighborhood.id}
      end
      if sub_neighborhood.present?
        location_params = {sub_neighborhood_id: sub_neighborhood.id}
      end
    else
      location_params = {city_id: 5915022}
    end
    location_params
  end

  # def self.arrange_as_array(options={}, hash=nil)
  #   hash ||= arrange(options)
  #
  #   arr = []
  #   hash.each do |node, children|
  #     arr << node
  #     arr += arrange_as_array(options, children) unless children.empty?
  #   end
  #   arr
  # end

  # def name_for_selects
  #   "#{'-' * level} #{name}"
  # end

  # def possible_parents
  #   parents = VerticalMarket.arrange_as_array(:order => 'name')
  #   return new_record? ? parents : parents - subtree
  # end

  def get_media_attachments_municipality(municipality = nil, city = nil, district = nil, neighborhood = nil, sub_neighborhood = nil)
    MediaAttachment.joins(location: :vertical_market_categories).where(locations: location_params(municipality, city, district, neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`media_attachments`.`created_at` DESC").limit(50)
  end

  def get_status_updates_municipality(municipality = nil, city = nil, district = nil, neighborhood = nil, add_subtrees = true, vertical_market_category = nil)
    status_updates = StatusUpdate.joins(location: :vertical_market_categories).where(locations: location_params(municipality, city, district, neighborhood))
    status_updates = status_updates.where(vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`status_updates`.`created_at` DESC").limit 200
  end

  def get_events_municipality(municipality = nil, city = nil, district = nil, neighborhood = nil, sub_neighborhood = nil)
    Event.joins(location: :vertical_market_categories).where("`events`.`ends_at` > CURRENT_TIMESTAMP").where(locations: location_params(municipality, city, district, neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`events`.`created_at` DESC").limit 50
  end

  def get_news_articles_municipality(municipality = nil, city = nil, district = nil, neighborhood = nil, sub_neighborhood = nil)
    NewsArticle.joins(location: :vertical_market_categories).where(locations: location_params(municipality, city, district, neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`news_articles`.`created_at` DESC").limit 50
  end

  def locations_of_civic_news municipality_slug, city_slug, district_slug, neighborhood_slug, sub_neighborhood_slug
    result_locations = []
    locations = []
    other_results = []

    if sub_neighborhood_slug.present?
      sub_nei = Neighborhood.find_by_slug(sub_neighborhood_slug)
      locations = Location.where(sub_neighborhood_id: sub_nei.id)
    elsif neighborhood_slug.present?
      nei = Neighborhood.find_by_slug(neighborhood_slug)
      locations = nei.locations
    elsif district_slug.present?
      district = District.find_by_slug(district_slug)
      locations = district.locations
    elsif city_slug.present?
      city = City.find_by_slug(city_slug)
      locations = city.locations
    elsif municipality_slug.present?
      municipality = Municipality.find_by_slug(municipality_slug)
      locations = municipality.locations
    else
      locations=[]
    end
    if locations.present?
      locations.each do|lo|
        result_locations = Location.where("hall_id = (?) OR councillor_id = (?) OR commissioner_id = (?)", lo.id, lo.id, lo.id)
      end
      other_results = Location.joins(:vertical_market_categories).where(vertical_market_categories: { vertical_market_id: [81, 82, 83]}).where(id: locations.pluck(:id))
    end
    result_locations += other_results
    temp = []
    result_locations.each_with_index do |i, idx|
      temp += i.media_attachments if i.media_attachments.size > 0
      temp += i.events if i.events.size > 0
      temp += i.news_articles if i.news_articles.size > 0
      temp += i.status_updates if i.status_updates.size > 0
    end
    result_locations += temp
  end
end
