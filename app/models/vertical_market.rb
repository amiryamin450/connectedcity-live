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

  def categories_new(city = nil, district = nil, neighborhood = nil)
    # FIXME MySQL 5.7 needs this to work properly.
    ActiveRecord::Base.connection.execute("SET sql_mode = ''")

    VerticalMarketCategory.joins(locations: [:city]).includes(locations: [:city]).where(vertical_market_id: self.subtree_ids, locations: location_params(city, district, neighborhood), maponics_subdivisions: { csdtype: 'CY' }).group("`vertical_market_categories`.`id`, `locations`.`id`").order("`vertical_market_categories`.`name` ASC")
  end

  def get_media_attachments(city = nil, district = nil, neighborhood = nil)
    MediaAttachment.joins(location: :vertical_market_categories).where(locations: location_params(city, district, neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`media_attachments`.`created_at` DESC").limit 10
  end

  def get_coupons(city = nil, district = nil, neighborhood = nil)
    Coupon.joins(location: :vertical_market_categories).where("`coupons`.`redemptions_count` < `coupons`.`howmany`").where(locations: location_params(city, district, neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`coupons`.`created_at` DESC").limit 10
  end

  def get_status_updates(city = nil, district = nil, neighborhood = nil, add_subtrees = true, vertical_market_category = nil)
    status_updates = StatusUpdate.joins(location: :vertical_market_categories).where(locations: location_params(city, district, neighborhood))

    if add_subtrees
      status_updates = status_updates.where(vertical_market_categories: { vertical_market_id: self.subtree_ids })
    elsif vertical_market_category
      status_updates = status_updates.where(vertical_market_categories: { id: vertical_market_category.id })
    end

    status_updates = status_updates.order("`status_updates`.`created_at` DESC").limit 10

    if [17, 18, 19, 20].include? self.id
      status_updates += StatusUpdate.where(statusable_type: ["RealEstateListing", "NewHomeCommunity", "RentalProperty"], vertical_markets: self.subtree_ids).where(location_params(city, district, neighborhood)).order("`status_updates`.`created_at` DESC").limit 10
      status_updates = status_updates.sort_by(&:created_at).last(10)
    end

    status_updates
  end

  def get_products(city = nil, district = nil, neighborhood = nil)
    products = Product.joins(location: :vertical_market_categories).where(locations: location_params(city, district, neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`products`.`created_at` DESC").limit 10
    products += Service.joins(location: :vertical_market_categories).where(locations: location_params(city, district, neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`services`.`created_at` DESC").limit 10
    products.sort_by(&:created_at).last(10)
  end

  def get_blog_entries(city = nil, district = nil, neighborhood = nil)
    BlogEntry.joins(location: :vertical_market_categories).where(locations: location_params(city, district, neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`blog_entries`.`created_at` DESC").limit 10
  end

  def get_events(city = nil, district = nil, neighborhood = nil)
    Event.joins(location: :vertical_market_categories).where("`events`.`ends_at` > CURRENT_TIMESTAMP").where(locations: location_params(city, district, neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`events`.`created_at` DESC").limit 10
  end

  def get_news_articles(city = nil, district = nil, neighborhood = nil)
    NewsArticle.joins(location: :vertical_market_categories).where(locations: location_params(city, district, neighborhood), vertical_market_categories: { vertical_market_id: self.subtree_ids }).order("`news_articles`.`created_at` DESC").limit 10
  end

  def location_params(city = nil, district = nil, neighborhood = nil)
    location_params = { city_id: city ? city.id : 5915022 }
    location_params[:district_id] = district.id if district
    location_params[:neighborhood_id] = neighborhood.id if neighborhood
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
end
