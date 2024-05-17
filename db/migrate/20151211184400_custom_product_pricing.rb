class CustomProductPricing < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :custom_pricing, :boolean
  end
end
