class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart
  attr_accessible :quantity, :product_id, :cart_id, :id, :price, :product_attributes

  validates :quantity, numericality: { only_integer: true }

  def total_price
    (price - discount) * quantity
  end

  def price
    product.price
  end

  def discount
    product.discount
  end

  def location
    self.product.location
  end

  def location_name
    location.name
  end

  def location_slug
    location.slug
  end

  def name_slug
    { name: location_name, slug: location_slug }
  end
end
