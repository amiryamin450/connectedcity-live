class ClassifiedListing < ApplicationRecord
  belongs_to :user
  belongs_to :classified_category
  belongs_to :province
  belongs_to :city
  belongs_to :neighborhood

  has_many :classified_images, dependent: :destroy

  default_scope { where(active: true) }

  validates_presence_of :condition, :description, :price, :title, :classified_category_id, :address, :city_id, :province_id, :postal_code

  accepts_nested_attributes_for :classified_images, :reject_if => lambda { |a| a[:image].nil? }, :allow_destroy => true

  monetize :price_cents
end
