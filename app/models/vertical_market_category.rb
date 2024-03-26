class VerticalMarketCategory < ApplicationRecord
  paginates_per 15
  extend FriendlyId
  belongs_to :vertical_market

  has_and_belongs_to_many :locations
  has_many :status_updates, -> { distinct },     through: :locations
  has_many :media_attachments, -> { distinct },  through: :locations
  has_many :coupons, -> { distinct },            through: :locations
  has_many :products, -> { distinct },           through: :locations
  has_many :services, -> { distinct },           through: :locations
  has_many :events, -> { distinct },             through: :locations
  has_many :news_articles, -> { distinct },      through: :locations
  has_many :blog_entries, -> { distinct },       through: :locations

  friendly_id :name, use: [:slugged, :history]

  has_attached_file :default_logo, :styles => {:thumb => "70x55", :list => "168x80"},
    :url => "/system/category/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/category/:id/:style/:basename.:extension"

  validates_attachment_size :default_logo, :less_than => 5.megabytes
  validates_attachment_content_type :default_logo, :content_type => ['image/jpeg', 'image/png']

  validates_presence_of :name
  validates_presence_of :vertical_market_id, :message => 'Please Select a Vertical Market.'

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "default_logo_content_type", "default_logo_file_name", "default_logo_file_size", "default_logo_updated_at", "description", "id", "name", "search_term", "slug", "updated_at", "vertical_market_id"]
  end

  def get_locations(city = nil, district = nil, neighborhood = nil, options={})
    result = locations.order("logo_updated_at DESC").order("name ASC").limit(20)
    result = result.where('locations.city_id = 5915022')
    result = result.where('locations.district_id = ?', district.id) if district.present?
    result = result.where('locations.neighborhood_id = ?', neighborhood.id) if neighborhood.present?
    result
  end

  def get_locations_paged(municipality = nil, city = nil, district = nil, neighborhood = nil, sub_neighborhood = nil, page = 0, bia = nil)
    result = locations.order(Arel.sql("IF(logo_file_name IS NULL, 0, 1) DESC")).order("updated_at DESC").order("name ASC")
    result = result.where('locations.municipality_id = ?', municipality.id) if municipality.present?
    result = result.where('locations.city_id = ?', city.id) if city.present?

    result = result.where('locations.district_id = ?', district.id) if district.present?
    result = result.where('locations.neighborhood_id = ?', neighborhood.id) if neighborhood.present?
    result = result.where('locations.sub_neighborhood_id = ?', sub_neighborhood.id) if sub_neighborhood.present?

    result.page(page).per(DEFAULT_PER_PAGE)
  end

  def get_auto_listings_paged(make, municipality = nil, city = nil, page = 1, district = nil, neighborhood = nil, sub_neighborhood = nil)
    AutomotiveListing.where(make: make).available_in(municipality, city, municipality, district, neighborhood, sub_neighborhood).page(page).per(DEFAULT_PER_PAGE)
  end
end
