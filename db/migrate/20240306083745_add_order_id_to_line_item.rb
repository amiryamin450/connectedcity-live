class AddOrderIdToLineItem < ActiveRecord::Migration[7.0]
  def change
    add_column :line_items, :paid, :boolean, default: false
    add_reference :line_items, :order, foreign_key: true
  end
end
