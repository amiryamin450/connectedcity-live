class RentalProperty < ActiveRecord::Base
  extend FriendlyId

  belongs_to :city
  belongs_to :province
  belongs_to :location
  belongs_to :neighborhood
  belongs_to :district

  has_many :rental_units
  has_many :status_updates, as: :statusable, dependent: :destroy

  attr_accessible :active, :address_1, :address_2, :city_id, :description,
  :email, :facebook_url, :fax, :garage_types, :included_utilities,
  :latitude, :longitude, :name, :neighborhood_description, :neighborhood_highlights,
  :neighborhood_id, :pet_restrictions, :phone, :phone_count, :postal_code, :pov,
  :property_features, :property_highlights, :province_id, :restrictions, :slug, :tag_line,
  :website_url, :location_id, :location, :cover_photo, :district_id, :status_updates_attributes

  friendly_id :name, use: [:slugged, :history]

  has_attached_file :cover_photo, :styles => { :thumb => "100x178", :list => "168x80" },
  :url => "/system/rental_properties/cover_photo/:id/:style/:basename.:extension",
  :path => ":rails_root/public/system/rental_properties/cover_photo/:id/:style/:basename.:extension"


  validates_presence_of :name, :address_1, :city_id, :province_id, :postal_code

  geocoded_by :full_street_address
  after_validation :geocode
  accepts_nested_attributes_for :status_updates, allow_destroy: true

  def logo
    self.cover_photo
  end

  def vertical_markets
    VerticalMarket.where(id: 17)
  end

  def vertical_market_categories
    nil
  end

  def full_street_address
    if city and province
      [address_1, city.name, province.preabbr, 'CA', postal_code].compact.join(', ')
    else
      ''
    end
  end


  def geo_location
    {:lat => latitude, :long => longitude}
  end

  before_save do
    self.neighborhood = Neighborhood.calculate(self.longitude, self.latitude) if self.geocoded?
    self.district = self.neighborhood.district if self.neighborhood.present? and self.neighborhood.district.present?
  end

  searchable do
    text :name, boost: 5
    text :address_1, boost: 3
    text :description
  end
end
