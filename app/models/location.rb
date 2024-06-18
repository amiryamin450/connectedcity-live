class Location < ApplicationRecord
  extend FriendlyId

  scope :profile, -> { where(is_profile: true) }
  scope :business, -> { where(is_profile: false) }

  acts_as_messageable

  before_validation :clear_images?

  belongs_to :super_admin, class_name: "User", optional: true
  alias :business_owner :super_admin

  belongs_to :business, optional: true
  belongs_to :city, optional: true
  belongs_to :country, optional: true
  belongs_to :province, optional: true
  belongs_to :district, optional: true
  belongs_to :neighborhood, optional: true
  belongs_to :sub_neighborhood, class_name: 'Neighborhood', foreign_key: 'sub_neighborhood_id', optional: true
  belongs_to :business_improvement_area, optional: true
  belongs_to :payment_user, class_name: 'User', optional: true
  belongs_to :municipality, optional: true
  belongs_to :user, optional: true

  has_many :agents, class_name: 'Location', foreign_key: 'broker_id', dependent: :destroy
  has_many :city_halls, class_name: 'Location', foreign_key: 'hall_id', dependent: :destroy
  has_many :city_councillors, -> { order 'name ASC' }, class_name: 'Location', foreign_key: 'councillor_id', dependent: :destroy
  has_many :park_recreation_commissioners, -> { order 'name ASC' }, class_name: 'Location', foreign_key: 'commissioner_id', dependent: :destroy
  belongs_to :broker, class_name: 'Location', optional: true
  belongs_to :hall, class_name: 'Location', optional: true
  belongs_to :councillor, class_name: 'Location', optional: true
  belongs_to :commissioner, class_name: 'Location', optional: true

  has_many :favorites, dependent: :destroy
  has_many :status_updates, as: :statusable, dependent: :destroy
  has_many :media_attachments, as: :attachable, dependent: :destroy
  has_many :videos, through: :media_attachments
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

  has_many :employment_listings
  has_many :coupons, dependent: :destroy
  has_many :automotive_listings, dependent: :destroy
  has_many :managers
  has_many :users, through: :managers
  has_many :social_profiles, as: :owner, dependent: :destroy
  has_many :conversations, foreign_key: :sender_id

  has_many :operating_hours, dependent: :destroy
  accepts_nested_attributes_for :operating_hours

  has_and_belongs_to_many :vertical_market_categories
  has_many :vertical_markets, through: :vertical_market_categories

  has_and_belongs_to_many :brands
  has_and_belongs_to_many :trade_associations

  friendly_id :slug_candidates, use: [:slugged, :history]

  def slug_candidates
    [:name, :name_and_sequence]
  end

  def name_and_sequence
    slug = normalize_friendly_id(name)
    sequence = Location.unscoped.where("slug like '#{slug}--%'").count + 2
    "#{slug}--#{sequence}"
  end

  attr_reader :brand_tokens
  attr_accessor :delete_cover_photo, :delete_logo

  has_attached_file :logo, :styles => { :thumb => "70x55", :list => "168x80", :bia_display => "250x100"},
    :url => "/system/location/logo/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/location/logo/:id/:style/:basename.:extension"

  validates_attachment_content_type :logo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  has_attached_file :cover_photo, :styles => { :thumb => "100x178", :cover => "1280" },
    :url => "/system/location/cover_photo/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/location/cover_photo/:id/:style/:basename.:extension",
    :default_url => "/default_images/location/cover_photo/cover/missing.jpg"

  validates_attachment_content_type :cover_photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  accepts_nested_attributes_for :location_images, :reject_if => lambda { |a| a[:image].nil? }, :allow_destroy => true
  accepts_nested_attributes_for :location_menus, :reject_if => lambda { |a| a[:image].nil? }, :allow_destroy => true
  accepts_nested_attributes_for :status_updates, allow_destroy: true
  accepts_nested_attributes_for :news_articles, allow_destroy: true
  accepts_nested_attributes_for :blog_entries, allow_destroy: true
  accepts_nested_attributes_for :products, allow_destroy: true
  accepts_nested_attributes_for :services, allow_destroy: true
  accepts_nested_attributes_for :events, allow_destroy: true
  accepts_nested_attributes_for :media_attachments, allow_destroy: true

  validates_presence_of :address, :name, :vertical_market_category_ids, :province_id, :country_id, :city_id, :district_id, :municipality_id, unless: :is_profile

  enum status: [:active, :in_active]

  def self.ransackable_attributes(auth_object = nil)
    ["address", "address_1", "available_call", "broker_id", "business_id", "business_improvement_area_id", "city_id", "claim_pending", "commissioner_id", "community_id", "content", "councillor_id", "country_id", "cover_photo_content_type", "cover_photo_file_name", "cover_photo_file_size", "cover_photo_updated_at", "created_at", "district_id", "email", "fax", "hall_id", "id", "import_hash", "imported", "is_profile", "latitude", "logo_content_type", "logo_file_name", "logo_file_size", "logo_updated_at", "longitude", "municipality_id", "name", "neighborhood_id", "payment_user_id", "phone", "postal_code", "province_id", "region_id", "show_fax", "show_phone", "show_toll_free", "slug", "stripe_account_id", "stripe_plan_id", "stripe_subscription_id", "sub_neighborhood_id", "toll_free", "updated_at", "vertical_market_category_id", "website_url", "yp_categories", "yp_lid", "yp_neighborhoods"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["agents", "automotive_listings", "blog_entries", "brands", "broker", "business", "business_improvement_area", "city", "city_councillors", "city_halls", "commissioner", "conversations", "councillor", "country", "coupons", "district", "employment_listings", "events", "favorites", "hall", "location_images", "location_menus", "managers", "media_attachments", "messages", "municipality", "neighborhood", "new_home_communities", "news_articles", "operating_hours", "park_recreation_commissioners", "payment_user", "products", "province", "real_estate_listings", "receipts", "rental_properties", "services", "slugs", "social_profiles", "status_updates", "sub_neighborhood", "trade_associations", "users", "vertical_market_categories", "vertical_markets", "videos"]
  end

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
    integer :sub_neighborhood_id
    integer :municipality_id
  end

  private
    def assign_neighborhood
      if longitude_changed? || latitude_changed?
        if (neighborhood_obj = Neighborhood.calculate(self.longitude, self.latitude))
          self.neighborhood_id = neighborhood_obj.id
          self.district_id = self.neighborhood.district.id if self.neighborhood.district
        end
      end
    end
end
