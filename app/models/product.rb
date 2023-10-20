class Product < ApplicationRecord
  belongs_to :location
  has_many :product_images, dependent: :destroy
  belongs_to :category
  has_many :variants, dependent: :destroy

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  accepts_nested_attributes_for :product_images, :reject_if => lambda { |a| a[:image].nil? }, :allow_destroy => true

  has_attached_file :image, styles: {
                              thumb: "50x50#", list: "320", display: "640"
                              },
                    :url => "/system/products/image/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/products/image/:id/:style/:basename.:extension",
                    default_url: "http://placehold.it/50x50"
  validates_attachment_presence :image

  validates :name, presence: true
  validates :category_id, presence: true
  validates :description, presence: true, length: { in: 100..1500 }
  validates :quantity, presence: true, numericality: { only_integer: true, minimum: 1, maximum: 1000 }
  validates :price, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ },
                    numericality: { greater_than: 0.1, less_than: 1000000 }
  validates :sku, length: { maximum: 25 }

  after_save do |product|
    Sunspot.index! product.location if product.location
  end

  def disabled
    quantity.nil? || quantity == 0
  end
end
