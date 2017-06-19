class RentalUnit < ActiveRecord::Base

  belongs_to :rental_property

  attr_accessible :availability, :bathrooms, :bedrooms, :date_available, :description,
  :flooring_types, :included_appliances, :living_area, :property_id, :rent_amount, :unit_number,
  :rental_property, :rental_property_id, :cover_photo

  has_attached_file :cover_photo, :styles => { :thumb => "100x178" },
    :url => "/system/rental_properties/cover_photo/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/rental_properties/cover_photo/:id/:style/:basename.:extension"


  searchable do
    text :description, boost: 5
    text :bathrooms
    text :bedrooms
	text :style
  end
end
