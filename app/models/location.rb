class Location < ActiveRecord::Base
  extend FriendlyId

  acts_as_messageable

  before_validation :clear_images?

  belongs_to :business
  belongs_to :city
  belongs_to :country
  belongs_to :province
  belongs_to :district
  belongs_to :neighborhood
  belongs_to :business_improvement_area
  belongs_to :payment_user, class_name: 'User'

  has_many :agents, class_name: 'Location', foreign_key: 'broker_id', dependent: :destroy
  belongs_to :broker, class_name: 'Location'

  has_many :favorites, dependent: :destroy
  has_many :status_updates, as: :statusable, dependent: :destroy
  has_many :media_attachments, as: :attachable, dependent: :destroy
  has_many :blog_entries, as: :bloggable, dependent: :destroy
  has_many :news_articles, as: :newsable, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :location_images, dependent: :destroy
  has_many :location_menus, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :real_estate_listings, dependent: :destroy
  has_many :rental_properties, dependent: :destroy
  has_many :new_home_communities, dependent: :destroy
  has_many :vertical_markets, through: :vertical_market_categories
  has_many :employment_listings
  has_many :coupons, dependent: :destroy
  has_many :automotive_listings, dependent: :destroy
  has_many :managers
  has_many :users, through: :managers
  has_many :social_profiles, as: :owner, dependent: :destroy

  has_many :operating_hours, order: :day, dependent: :destroy
  accepts_nested_attributes_for :operating_hours

  has_and_belongs_to_many :vertical_market_categories, :order => 'name ASC'
  has_and_belongs_to_many :brands
  has_and_belongs_to_many :trade_associations

  friendly_id :name, use: [:slugged, :history]
  attr_reader :brand_tokens
  attr_accessor :delete_cover_photo, :delete_logo

  attr_accessible :address, :address_1, :business_id, :city_id, :community_id, :country_id, :email, :fax, :import_hash,
    :imported, :latitude, :longitude, :name, :phone, :postal_code, :region_id, :show_fax, :show_phone,
    :show_toll_free, :slug, :province_id, :toll_free, :website_url, :logo,
    :location_images_attributes, :location_menus_attributes, :vertical_market_category_ids, :status_updates_attributes,
    :blog_entries_attributes, :news_articles_attributes, :products_attributes, :services_attributes, :events_attributes,
    :brand_ids, :brand_tokens, :content, :vertical_market_categories, :district, :yp_lid, :yp_categories, :yp_neighborhoods,
    :city, :province, :district_id, :neighborhood, :country, :cover_photo, :neighborhood_id, :broker_id, :business_improvement_area_id,
    :user, :trade_association_ids, :media_attachments_attributes, :delete_cover_photo, :delete_logo,
    :operating_hours_attributes, :stripe_plan_id

  has_attached_file :logo, :styles => { :thumb => "70x55", :list => "168x80", :bia_display => "250x100"},
    :url => "/system/location/logo/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/location/logo/:id/:style/:basename.:extension"
    # ,
    # :default_url => "http://placehold.it/250x150"

  has_attached_file :cover_photo, :styles => { :thumb => "100x178", :cover => "1280" },
    :url => "/system/location/cover_photo/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/location/cover_photo/:id/:style/:basename.:extension",
    :default_url => "/default_images/location/cover_photo/cover/missing.jpg"

  accepts_nested_attributes_for :location_images, :reject_if => lambda { |a| a[:image].nil? }, :allow_destroy => true
  accepts_nested_attributes_for :location_menus, :reject_if => lambda { |a| a[:image].nil? }, :allow_destroy => true
  accepts_nested_attributes_for :status_updates, allow_destroy: true
  accepts_nested_attributes_for :news_articles, allow_destroy: true
  accepts_nested_attributes_for :blog_entries, allow_destroy: true
  accepts_nested_attributes_for :products, allow_destroy: true
  accepts_nested_attributes_for :services, allow_destroy: true
  accepts_nested_attributes_for :events, allow_destroy: true
  accepts_nested_attributes_for :media_attachments, allow_destroy: true

  validates_presence_of :address, :name, :vertical_market_category_ids

  geocoded_by :full_street_address

  after_validation :geocode
  after_save :assign_neighborhood

  def self.find_by_vertical_market
    vertical_market_categories
  end

  def user_owns?(user)
    self.users.where(id: user.id).any?
  end

  def user_can_manage?(user)
    self.users.where(id: user.id).any? && self.claim_pending == false
  end

  def clear_images?
    logo.clear if delete_logo == '1'
    cover_photo.clear if delete_cover_photo == '1'
  end

  def brand_tokens=(ids)
    self.brand_ids = ids.split(',')
  end

  def filter_name
    "#{name} (#{address})"
  end

  def full_street_address
    if city and province
      [address, city.name, province.name, 'CA', postal_code].compact.join(', ')
    else
      ''
    end
  end

  def short_address
    "#{address}, #{city.name}, #{province.abbr} #{postal_code}"
  end

  def geo_location
    {:lat => latitude, :long => longitude}
  end

  searchable do
    text :name, boost: 5
    text :address, boost: 3

    text :content, :phone

    text :brand, boost: 3 do
      brands.map(&:name)
    end

    text :product, boost: 3 do
      products.map(&:name)
    end

    text :service, boost: 3 do
      services.map(&:name)
    end

    text :category do
      vertical_market_categories.map(&:name)
    end

    text :vertical_market_name do
      vertical_markets.map(&:name)
    end

    text :city do
      city.name if city.present?
    end

    integer :vertical_market_ids, :multiple => true do
      vertical_markets.map(&:id)
    end

    integer :district_id
    integer :city_id
    integer :business_improvement_area_id
    integer :neighborhood_id


  end

  private
    def assign_neighborhood
      if longitude_changed? || latitude_changed?
        if self.geocoded? && (neighborhood_obj = Neighborhood.calculate(self.longitude, self.latitude))
          self.neighborhood_id = neighborhood_obj.id
          self.district_id = self.neighborhood.district.id if self.neighborhood.district
        end
      end
    end
end
