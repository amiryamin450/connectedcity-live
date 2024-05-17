class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart, optional: true
  belongs_to :order, optional: true

  scope :un_paid, -> { where(paid: false) }
  scope :paid, -> { where(paid: true) }

  validates :quantity, numericality: { only_integer: true }

  before_validation :make_sure_line_item_belongs_to_cart_or_order

  def make_sure_line_item_belongs_to_cart_or_order
    errors.add('Line item must belongs to whether cart or order!') unless cart_id.present? || order_id.present?
  end

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
