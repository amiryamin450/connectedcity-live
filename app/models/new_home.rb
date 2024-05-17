class NewHome < ApplicationRecord

  belongs_to :city
  belongs_to :province
  belongs_to :new_home_community

  extend FriendlyId
  friendly_id :slugged_address, use: [:slugged, :history]

  has_attached_file :cover_photo, :styles => { :thumb => "100x178" },
    :url => "/system/new_homes/cover_photo/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/new_homes/cover_photo/:id/:style/:basename.:extension"

  geocoded_by :full_street_address

  validates_presence_of :address, :title, :city, :province, :postal_code

  after_validation :geocode

  def full_street_address
    if city and province
      [address, city.name, province.name, 'CA', postal_code].compact.join(', ')
    else
      ''
    end
  end

  def slugged_address
    "#{address} #{city.name} #{province.abbr}"
  end

  searchable do
    text :title, boost: 5
    text :address, boost: 3
    text :description
    text :bathroom_comment
    text :bedroom_comment
    integer :bathrooms
    integer :bedrooms
  end
end
