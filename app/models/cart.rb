class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy

  attr_accessible :line_items_attributes

  accepts_nested_attributes_for :line_items, allow_destroy: true

  def add_product(product, quantity)
    current_item = line_items.find_by_product_id(product.id)
    if current_item
      current_item.quantity += quantity.to_i
    else
      current_item = line_items.build(product_id: product.id, quantity: quantity.to_i)
    end
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end
end
