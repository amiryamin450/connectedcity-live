class Service < ActiveRecord::Base
  belongs_to :location

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  attr_accessible :description, :name, :sku, :slug, :location_id, :image, :price

  validates_presence_of :description, :name, :price

  has_attached_file :image, styles: {
    thumb: "150x150#", list: "320x200#"
  }

end
