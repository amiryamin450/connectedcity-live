class RealEstateListing < ApplicationRecord
  belongs_to :city
  belongs_to :country
  belongs_to :province
  belongs_to :location
  belongs_to :district
  belongs_to :neighborhood

  has_many :real_estate_listing_images, dependent: :destroy
  has_many :status_updates, as: :statusable, dependent: :destroy

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  geocoded_by :full_street_address

  searchable do
    text :regional_mls_number, boost: 5
    text :address, boost: 5
    text :title, boost: 3
    text :city
    text :description
    text :lot_comment
    text :lot_legal
    text :bedroom_comment, boost: 3
    text :bathroom_comment, boost: 3
    text :garage_comment

    integer :bedrooms
    integer :bathrooms

    float :list_price
    float :rental_price

    text :location
    text :property_type

    text :city do
      city.name if city.present?
    end

    # real_estate_listings has no municipality_id or sub_neighborhood_id columns (these fields
    # were copied from Location). Derive them from the listing's own city and neighborhood;
    # its `location` is the agent's business profile, not the property.
    integer :municipality_id do
      city&.municipality_id
    end
    integer :district_id
    integer :city_id
    integer :neighborhood_id
    integer :sub_neighborhood_id do
      neighborhood_id if neighborhood&.neighborhood_id.present?
    end
  end

  has_attached_file :main_image, styles: {
                            thumb: "50x50#", list: "168x80#", bia_display: "250x100"
                            },
                  default_url: "http://placehold.it/320x200",
                  :url => "/system/real_estate_listings/main_images/:id/:style/:basename.:extension",
  :path => ":rails_root/public/system/real_estate_listings/main_images/:id/:style/:basename.:extension"

  validates_presence_of :title, :list_price, :city_id, :province_id, :location_id, :address
  accepts_nested_attributes_for :real_estate_listing_images, :reject_if => lambda { |a| a[:image].nil? }, :allow_destroy => true
  after_validation :geocode
  accepts_nested_attributes_for :status_updates, allow_destroy: true

  STYLES = %w(Condominiums Houses Townhomes)

  def geo_location
    {:lat => latitude, :long => longitude}
  end

  def logo
    self.main_image
  end

  def vertical_markets
    case self.property_type
    when 'Commercial'
      VerticalMarket.where(id: 20)
    when 'Residential'
      VerticalMarket.where(id: 18)
    else
      nil
    end
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

  def name
    [address, city.name].compact.join(', ')
  end

  before_save do
    self.neighborhood = Neighborhood.calculate(self.longitude, self.latitude) if self.geocoded?
    self.district = self.neighborhood.district if self.neighborhood.present? and self.neighborhood.district.present?
  end
end
