class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :line_items, allow_destroy: true

  attr_accessor :list_items

  def add_product(product, quantity)
    current_item = line_items.find_by_product_id(product.id)
    qty_product = product.quantity

    if current_item
      qty_current = current_item.quantity
      qty_update = qty_current + quantity.to_i > qty_product ? qty_product : qty_current += quantity.to_i
      current_item.quantity = qty_update
    else
      qty_update = quantity.to_i > qty_product ? qty_product : quantity.to_i
      current_item = line_items.build(product_id: product.id, quantity: qty_update)
    end
    current_item
  end

  # workflow get province just spend for one item in database is british-columbia
  def province
    line_items.first.product&.location&.province
  end

  def tax_pst
    province&.tax_pst || 0.0
  end

  def tax_gst
    province&.tax_gst || 0.0
  end

  def tax_hst
    province&.tax_hst || 0.0
  end

  def tax_pst_format
    '%.1f' % (tax_pst * 100)
  end

  def tax_gst_format
    '%.1f' % (tax_gst * 100)
  end

  def tax_hst_format
    '%.1f' % (tax_hst * 100)
  end

  def has_tax_pst
    tax_pst > 0.0
  end

  def has_tax_gst
    tax_gst > 0.0
  end

  def has_tax_hst
    tax_hst > 0.0
  end

  def tax_pst_price
    tax_pst * total_price_net
  end

  def tax_gst_price
    tax_gst * total_price_net
  end

  def total_tax
    tax_pst_price + tax_gst_price
  end

  def total_price_net
    list_items.to_a.sum { |item| item.total_price }
  end

  def total_price_gross
    total_price_net + total_tax
  end

  def total_quantity
    line_items.to_a.sum { |item| item.quantity }
  end

  def full
    total_quantity >= 50
  end

  def list_items
    @list_items
  end
end
