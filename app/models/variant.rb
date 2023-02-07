class Variant < ActiveRecord::Base
  has_many :options, dependent: :destroy
  belongs_to :product
  attr_accessible :name, :price, :sku, :product_id
end
