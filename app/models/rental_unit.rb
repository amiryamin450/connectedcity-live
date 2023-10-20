class RentalUnit < ApplicationRecord
  belongs_to :rental_property

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
