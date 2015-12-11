class CustomProductPricing < ActiveRecord::Migration
  def change
    add_column :products, :custom_pricing, :boolean
  end
end
