class VerticalMarketCategory < ActiveRecord::Base
  paginates_per 15
  extend FriendlyId
  belongs_to :vertical_market

  has_and_belongs_to_many :locations
  has_many :status_updates,     :through => :locations, uniq: true
  has_many :media_attachments,  :through => :locations, uniq: true
  has_many :coupons,            :through => :locations, uniq: true
  has_many :products,           :through => :locations, uniq: true
  has_many :services,           :through => :locations, uniq: true
  has_many :events,             :through => :locations, uniq: true
  has_many :news_articles,      :through => :locations, uniq: true
  has_many :blog_entries,       :through => :locations, uniq: true

  # This is actually broken in MySQL 5.7
  # default_scope order('vertical_market_categories.name')

  attr_accessible :description, :name, :slug, :vertical_market_id, :default_logo, :search_term
  friendly_id :name, use: [:slugged, :history]

  has_attached_file :default_logo, :styles => {:thumb => "70x55", :list => "168x80"},
    :url => "/system/category/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/category/:id/:style/:basename.:extension"

  validates_attachment_size :default_logo, :less_than => 5.megabytes
  validates_attachment_content_type :default_logo, :content_type => ['image/jpeg', 'image/png']

  validates_presence_of :name
  validates_presence_of :vertical_market_id, :message => 'Please Select a Vertical Market.'

  def get_locations(city = nil, district = nil, neighborhood = nil, options={})
    result = locations.order("logo_updated_at DESC").order("name ASC").limit(20)
    result = result.where('locations.city_id = 5915022')
    result = result.where('locations.district_id = ?', district.id) if district.present?
    result = result.where('locations.neighborhood_id = ?', neighborhood.id) if neighborhood.present?
    result
  end


  def get_locations_paged(city = nil, district = nil, neighborhood = nil, page = 0, bia = nil)

    result = locations.order("IF(logo_file_name IS NULL, 0, 1) DESC").order("updated_at DESC").order("name ASC")
    result = result.where('locations.city_id = 5915022')
    result = result.where(business_improvement_area_id: bia.id) if bia.present?
    result = result.where('locations.district_id = ?', district.id) if district.present?
    result = result.where('locations.neighborhood_id = ?', neighborhood.id) if neighborhood.present?
    # result = result.where
    result.page(page).per(DEFAULT_PER_PAGE)
  end

  def get_auto_listings_paged(make, city, page = 1, district = nil, neighborhood = nil)
    AutomotiveListing.where(make: make).available_in(city, district, neighborhood).page(page).per(DEFAULT_PER_PAGE)
  end
end
