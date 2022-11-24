class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart
  attr_accessible :quantity, :product_id, :cart_id

  def total_price
    (product.price - product.discount) * quantity
  end

  def location_name
    self.product.location.name
  end
end
