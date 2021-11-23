class AddDiscountToProducts < ActiveRecord::Migration
  def change
    add_column :products, :discount, :decimal, default: 0
  end
end
