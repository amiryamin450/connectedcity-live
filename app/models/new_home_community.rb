class NewHomeCommunity < ActiveRecord::Base

  belongs_to :city
  belongs_to :province
  belongs_to :neighborhood
  belongs_to :location
  belongs_to :district

  has_many :new_homes
  has_many :status_updates, as: :statusable, dependent: :destroy

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  attr_accessible :city_id, :description, :highlights, :location_id, :name,
  :neighborhood_id, :province_id, :city, :province, :location, :neighborhood, :district_id, :cover_photo,
  :address, :postal_code, :latitude, :longitude, :status_updates_attributes, :logo, :style

  geocoded_by :full_street_address
  after_validation :geocode
  accepts_nested_attributes_for :status_updates, allow_destroy: true

  has_attached_file :cover_photo, :styles => { :thumb => "100x178", :list => "168x80" },
  :url => "/system/new_home_communities/cover_photo/:id/:style/:basename.:extension",
  :path => ":rails_root/public/system/new_home_communities/cover_photo/:id/:style/:basename.:extension"

  has_attached_file :logo, :styles => { :thumb => "70x55", :list => "168x80", :bia_display => "250x100"},
  :url => "/system/new_home_communities/logo/:id/:style/:basename.:extension",
  :path => ":rails_root/public/system/new_home_communities/logo/:id/:style/:basename.:extension"

  STYLES = %w(Condominiums Houses Townhomes)

  def vertical_markets
    VerticalMarket.where(id: 19)
  end

  def vertical_market_categories
    nil
  end

  def full_street_address
    if city and province
      [address, city.name, province.name, 'CA', postal_code].compact.join(', ')
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
    text :address, boost: 3
    text :description, :highlights
  end
end
