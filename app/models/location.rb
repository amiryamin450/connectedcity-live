class Location < ActiveRecord::Base
  extend FriendlyId
  extend TireHelper
  include Tire::Model::Search
  include Tire::Model::Callbacks

  # default_scope includes(:district, :vertical_market_categories, :country, :province, :city => [:region])

  belongs_to :business
  belongs_to :city
  belongs_to :country
  belongs_to :province
  belongs_to :region
  belongs_to :district

  has_many :favorites, dependent: :destroy
  has_many :status_updates, as: :statusable, dependent: :destroy
  has_many :blog_entries, as: :bloggable, dependent: :destroy
  has_many :news_articles, as: :newsable, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :location_images, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :real_estate_listings

  has_and_belongs_to_many :vertical_market_categories
  has_and_belongs_to_many :brands

  

  # adding a comment to test github integration
  # more testing

  
  friendly_id :name, use: [:slugged, :history]

  attr_accessible :address, :address_1, :business_id, :city_id, :community_id, :country_id, :email, :fax, :import_hash,
    :imported, :latitude, :longitude, :name, :phone, :postal_code, :region_id, :show_fax, :show_phone,
    :show_toll_free, :slug, :province_id, :toll_free, :website_url, :logo,
    :location_images_attributes, :vertical_market_category_ids, :status_updates_attributes,
    :blog_entries_attributes, :news_articles_attributes, :products_attributes, :services_attributes, :events_attributes,
    :brand_ids, :brand_tokens, :content, :vertical_market_categories, :district, :yp_lid, :yp_categories, :yp_neighborhoods,
    :city, :province, :district_id, :neighborhood, :country, :cover_photo

  attr_reader :brand_tokens

  has_attached_file :logo, :styles => { :thumb => "70x55"},
    :url => "/assets/location_logo/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/location_logo/:id/:style/:basename.:extension"

  has_attached_file :cover_photo, :styles => { :thumb => "100x178" },
    :url => "/assets/location/cover_photo/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/location/cover_photo/:id/:style/:basename.:extension"

  accepts_nested_attributes_for :location_images, :reject_if => lambda { |a| a[:image].nil? }, :allow_destroy => true
  accepts_nested_attributes_for :status_updates, allow_destroy: true
  accepts_nested_attributes_for :news_articles, allow_destroy: true
  accepts_nested_attributes_for :blog_entries, allow_destroy: true
  accepts_nested_attributes_for :products, allow_destroy: true
  accepts_nested_attributes_for :services, allow_destroy: true
  accepts_nested_attributes_for :events, allow_destroy: true

  validates_presence_of :address, :name

  geocoded_by :full_street_address 
  
  after_validation :geocode

  mapping do
    indexes :id, type: 'integer', index: :not_analyzed
    indexes :name, type: 'string', analyzer: 'snowball', boost: 10
    indexes :name_sort, type: 'string', index: :not_analyzed
    indexes :short_address, type: 'string', analyzer: 'snowball'
    indexes :content, type: 'string', analyzer: 'snowball'

    indexes :city do
      indexes :id, type: 'integer', index: :not_analyzed
      indexes :name, type: 'string', index: :not_analyzed
      indexes :sub_region_id, type: 'integer', index: :not_analyzed
    end

    indexes :province do
      indexes :id, type: 'integer', index: :not_analyzed
      indexes :name, type: 'string', index: :not_analyzed
      indexes :abbr, type: 'string', index: :not_analyzed
    end

    indexes :country do
      indexes :id, type: 'integer', index: :not_analyzed
      indexes :name, type: 'string', index: :not_analyzed
    end

    indexes :region do
      indexes :id, type: 'integer', index: :not_analyzed
      indexes :name, type: 'string', index: :not_analyzed
    end

    indexes :district do
      indexes :id, type: 'integer', index: :not_analyzed
      indexes :name, type: 'string', index: :not_analyzed
    end

    indexes :postal_code, type: 'string', index: :not_analyzed
    indexes :phone, type: 'string', index: :not_analyzed
    indexes :fax, type: 'string', index: :not_analyzed
    indexes :email, type: 'string', index: :not_analyzed
    indexes :tall_free, type: 'string', index: :not_analyzed
    indexes :show_phone, type: 'boolean'
    indexes :show_fax, type: 'boolean'
    indexes :show_toll_free, type: 'boolean'
    indexes :website_url, type: 'string', index: :not_analyzed
    indexes :logo_thumb, type: 'string', index: :not_analyzed
    indexes :slug, type: 'string', index: :not_analyzed
    indexes :neighborhoods, type: 'string', index_name: 'neighborhoods', index: :not_analyzed
    indexes :categories, type: 'string', index_name: 'categories', index: :not_analyzed
    indexes :brands, type: 'string', index: :not_analyzed

    indexes :geo, type: 'geo_point'
  end


  def to_indexed_json
    {
      :id => id,
      :name => name,
      :name_sort => name,
      :short_address => self.short_address,
      :address => address,
      :address_1 => address_1,
      :city => {
        :name => city.name,
        :id => city_id,
        :sub_region_id => city.sub_region_id
      },
      :province => {
        :abbr => province.abbr,
        :name => province.name,
        :id => province_id
      },
      :country => {
        :country_code => country.country_code,
        :id => country_id,
        :name => country.name
      },
      :region => {
        :id => city.region.id,
        :name => city.region.name
      },
      :district => {
        :id => district.nil? ? nil : district_id,
        :name => district.nil? ? nil : district.name
      },
      :postal_code => postal_code,
      :phone => phone,
      :fax => fax,
      :email => email,
      :toll_free => toll_free,
      :show_phone => show_phone,
      :show_fax => show_fax,
      :show_toll_free => show_toll_free,
      :geo => [latitude, longitude],
      :website_url => website_url,
      :logo_thumb => logo.url(:thumb),
      :slug => slug,
      :neighborhoods => yp_neighborhoods.nil? ? nil : yp_neighborhoods.split(','),
      :categories => yp_categories.nil? ? nil : yp_categories.split(','),
      :yp_lid => yp_lid,
      :content => content,
      :vertical_market_categories => vertical_market_categories,
      :brands => brands.map { |b| b.name.downcase }
    }.to_json
  end





  def brand_tokens=(ids)
    self.brand_ids = ids.split(',')
  end

  def filter_name
    "#{name} (#{address})"
  end

  def full_street_address
    [address, city.name, province.name, country.country_code, postal_code].compact.join(', ')
  end

  def short_address
    "#{address}, #{city.name}, #{province.abbr} #{postal_code}"
  end

  def geo_location
    {:lat => latitude, :long => longitude}
  end


end
