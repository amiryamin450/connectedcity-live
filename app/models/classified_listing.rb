class ClassifiedListing < ActiveRecord::Base

  belongs_to :user
  has_many :classified_images, dependent: :destroy
  belongs_to :classified_category
  belongs_to :province
  belongs_to :city
  belongs_to :neighborhood

  default_scope where(active: true)


  attr_accessible :condition, :description, :price_cents, :title, :price, :classified_category_id, :address,
                  :address_1, :city_id, :province_id, :postal_code, :neighborhood_id, :active, :classified_images_attributes



  validates_presence_of :condition, :description, :price, :title, :classified_category_id, :address, :city_id, :province_id, :postal_code
  accepts_nested_attributes_for :classified_images, :reject_if => lambda { |a| a[:image].nil? }, :allow_destroy => true
  monetize :price_cents

end
