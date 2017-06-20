class RealEstateListing < ActiveRecord::Base

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

      integer :district_id
      integer :city_id
      integer :neighborhood_id
    end

    attr_accessible  :listing_source,
                     :email,
                     :web_bug_url,
                     :listing_source_id,
                     :provider_listing_id,
                     :provider,
                     :regional_mls_number,
                     :regional_mls_number_visible,
                     :last_update_date,
                     :status,
                     :title,
                     :detail_view_url,
                     :country,
                     :province,
                     :address,
                     :address_visible,
                     :address_suite,
                     :postal_code,
                     :latitude,
                     :longitude,
                     :city,
                     :description,
                     :list_price,
                     :tax_amount,
                     :property_type,
                     :style,
                     :lot_comment,
                     :lot_legal,
                     :rental_price,
                     :rental_period,
                     :rental_currency,
                     :bedrooms,
                     :bedroom_comment,
                     :bathrooms,
                     :bathroom_comment,
                     :garage,
                     :garage_stalls,
                     :garage_style,
                     :garage_comment,
                     :living_area,
                     :living_area_unit,
                     :year_built,
                     :year_built_comment,
                     :broker_name,
                     :list_date,
                     :virtual_tour_url,
                     :association_fee,
                     :association_fee_period,
                     :association_fee_currency,
                     :neighborhood,
                     :location,
                     :slug,
                     :city_id,
                     :country_id,
                     :province_id,
                     :location_id,
                     :main_image,
                     :real_estate_listing_images,
                     :district_id,
                     :neighborhood_id,
                     :status_updates_attributes,
                     :real_estate_listing_images_attributes


   has_attached_file :main_image, styles: {
                              thumb: "50x50#", list: "168x80#"
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
