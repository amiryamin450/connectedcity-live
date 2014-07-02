class VerticalMarket < ActiveRecord::Base

  has_ancestry :cache_depth => true, :depth_cache_column => :ancestry_depth

  has_many :vertical_market_categories
  has_many :locations,          :through => :vertical_market_categories
  has_many :status_updates,     :through => :locations, uniq: true
  has_many :products,           :through => :locations, uniq: true
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
    categories = vertical_market_categories
    if self.has_children?
      self.children.each do |child|
        categories += child.vertical_market_categories
      end
    end
    categories.sort_by(&:name)
  end

  def get_media_attachments(city = nil, district = nil, neighbrhd = nil)
    result = media_attachments.limit(10)
    result = result.where('locations.city_id = ?', 5915022)
    result = result.where('locations.district_id = ?', district.id) if district.present?
    result = result.where('locations.neighborhood_id = ?', neighbrhd.id) if neighbrhd.present?
    result
  end

  def get_coupons(city = nil, district = nil, neighbrhd = nil)
    result = coupons.where('coupons.redemptions_count < coupons.howmany').limit(10)
    result = result.where('locations.city_id = ?', 5915022)
    result = result.where('locations.district_id = ?', district.id) if district.present?
    result = result.where('locations.neighborhood_id = ?', neighbrhd.id) if neighbrhd.present?
    result
  end
  
  def get_status_updates(city = nil, district = nil, neighbrhd = nil, add_subtrees = true, vertical_market_category = nil)
    result = VerticalMarketCategory.includes(:status_updates)
    result = result.where(vertical_market_id: self.subtree_ids) if add_subtrees
    result = result.where(id: vertical_market_category.id) if vertical_market_category.present? and !add_subtrees

    result = result.where('locations.city_id = ?', 5915022)
    result = result.where('locations.district_id = ?', district.id) if district.present?
    result = result.where('locations.neighborhood_id = ?', neighbrhd.id) if neighbrhd.present?
    result = result.map { |c| c.status_updates.present? ? c.status_updates : nil }.compact.flatten.sort_by { |obj| obj.created_at }.uniq.reverse!.first(10)

    if !([self.id] & [17,18,19,20]).empty?
      second_result = StatusUpdate.where(statusable_type: ['RealEstateListing','NewHomeCommunity','RentalProperty']).where(city_id: 5915022).where(vertical_markets: self.subtree_ids)
      second_result = second_result.where(district_id: district.id) if district.present?
      second_result = second_result.where(neighborhood_id: neighbrhd.id) if neighbrhd.present?
      
      result += second_result.flatten
      result = result.sort_by { |obj| obj.created_at }.uniq.reverse!.first(10)
    end

    result
  end

  def get_products(city = nil, district = nil, neighbrhd = nil)
    result = products.limit(10)

    result = result.where('locations.city_id = ?', 5915022) 
    result = result.where('locations.district_id = ?', district.id) if district
    result = result.where('locations.neighborhood_id = ?', neighbrhd.id) if neighbrhd.present?
    result
  end

  def get_blog_entries(city = nil, district = nil, neighbrhd = nil)
    result = blog_entries.limit(10)

    result = result.where('locations.city_id = ?', city.id) if city
    result = result.where('locations.district_id = ?', district.id) if district
    result = result.where('locations.neighborhood_id = ?', neighbrhd.id) if neighbrhd.present?
    result
  end

  def get_events(city = nil, district = nil, neighbrhd = nil)
    result = events.limit(10)

    result = result.where('locations.city_id = ?', 5915022) 
    result = result.where('locations.district_id = ?', district.id) if district
    result = result.where('locations.neighborhood_id = ?', neighbrhd.id) if neighbrhd.present?
    result
  end

  def get_news_articles(city = nil, district = nil, neighbrhd = nil)
    result = news_articles.limit(10)

    result = result.where('locations.city_id = ?', 5915022) 
    result = result.where('locations.district_id = ?', district.id) if district
    result = result.where('locations.neighborhood_id = ?', neighbrhd.id) if neighbrhd.present?
    result
  end

  def self.arrange_as_array(options={}, hash=nil)
    hash ||= arrange(options)

    arr = []
    hash.each do |node, children|
      arr << node
      arr += arrange_as_array(options, children) unless children.empty?
    end
    arr
  end

  def name_for_selects
    "#{'-' * level} #{name}"
  end

  def possible_parents
    parents = VerticalMarket.arrange_as_array(:order => 'name')
    return new_record? ? parents : parents - subtree
  end

end
