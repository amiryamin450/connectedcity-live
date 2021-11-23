class Product < ActiveRecord::Base
  belongs_to :location
  has_many :product_images, dependent: :destroy

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  accepts_nested_attributes_for :product_images, :reject_if => lambda { |a| a[:image].nil? }, :allow_destroy => true

  attr_accessible :description, :name, :price, :sku, :slug, :product_id, :quantity, :image, :custom_pricing, :discount, :product_images_attributes

  has_attached_file :image, styles: {
                              thumb: "50x50#", list: "320", display: "640"
                              },
                    :url => "/system/products/image/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/products/image/:id/:style/:basename.:extension",
                    default_url: "http://placehold.it/50x50"

  validates_presence_of :description, :name, :price

  after_save do |product|
    Sunspot.index! product.location if product.location
  end
end
