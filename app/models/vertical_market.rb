class VerticalMarket < ActiveRecord::Base

  has_ancestry :cache_depth => true, :depth_cache_column => :ancestry_depth

  has_many :vertical_market_categories
  has_many :locations,          :through => :vertical_market_categories
  has_many :status_updates,     :through => :locations, uniq: true
  has_many :products,           :through => :locations, uniq: true
  has_many :blog_entries,       :through => :locations, uniq: true
  has_many :events,             :through => :locations, uniq: true
  has_many :news_articles,      :through => :locations, uniq: true

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



  def get_status_updates(region = nil, subregion = nil, city = nil, district = nil)
    result = status_updates.where('locations.region_id = ?', region.id) if region
    result = result.where('locations.subregion_id = ?', subregion.id) if subregion
    result = result.where('locations.city_id = ?', city.id) if city
    result = result.where('locations.district_id = ?', district.id) if district
    result.to_a
  end

  def get_products(region = nil, subregion = nil, city = nil, district = nil)
    result = products.where('locations.region_id = ?', region.id) if region
    result = result.where('locations.subregion_id = ?', subregion.id) if subregion
    result = result.where('locations.city_id = ?', city.id) if city
    result = result.where('locations.district_id = ?', district.id) if district
    result.to_a
  end

  def get_blog_entries(region = nil, subregion = nil, city = nil, district = nil)
    result = blog_entries.where('locations.region_id = ?', region.id) if region
    result = result.where('locations.subregion_id = ?', subregion.id) if subregion
    result = result.where('locations.city_id = ?', city.id) if city
    result = result.where('locations.district_id = ?', district.id) if district
    result.to_a
  end

  def get_events(region = nil, subregion = nil, city = nil, district = nil)
    result = events.where('locations.region_id = ?', region.id) if region
    result = result.where('locations.subregion_id = ?', subregion.id) if subregion
    result = result.where('locations.city_id = ?', city.id) if city
    result = result.where('locations.district_id = ?', district.id) if district
    result.to_a
  end

  def get_news_articles(region = nil, subregion = nil, city = nil, district = nil)
    result = news_articles.where('locations.region_id = ?', region.id) if region
    result = result.where('locations.subregion_id = ?', subregion.id) if subregion
    result = result.where('locations.city_id = ?', city.id) if city
    result = result.where('locations.district_id = ?', district.id) if district
    result.to_a
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
