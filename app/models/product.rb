class Product < ActiveRecord::Base
  belongs_to :location

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  attr_accessible :description, :name, :price, :sku, :slug, :product_id, :image

  has_attached_file :image, styles: {
                              thumb: "50x50#", list: "320", display: "640"
                              },
                    :url => "/system/products/image/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/products/image/:id/:style/:basename.:extension",
                    default_url: "http://placehold.it/50x50"

  validates_presence_of :description, :name, :price
end
