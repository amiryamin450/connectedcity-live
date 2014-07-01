class RealEstateListing < ActiveRecord::Base

    belongs_to :city
    belongs_to :country
    belongs_to :province
    belongs_to :location

    extend FriendlyId
    friendly_id :title, use: [:slugged, :history]

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
                     :main_image


   has_attached_file :main_image, styles: {
                              thumb: "50x50#", list: "320x200#"
                              },
                    default_url: "http://placehold.it/320x200"

   validates_presence_of :title, :list_price, :city_id, :province_id, :location_id, :address

end