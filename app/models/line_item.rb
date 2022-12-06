class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart
  attr_accessible :quantity, :product_id, :cart_id, :id, :price, :product_attributes

  def total_price
    (price - discount) * quantity
  end

  def price
    product.price
  end

  def discount
    product.discount
  end

  def location_name
    self.product.location.name
  end
end
