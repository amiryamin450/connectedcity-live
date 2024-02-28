class AddRedeemedToRedemptions < ActiveRecord::Migration[7.0]
  def change
    add_column :redemptions, :redeemed, :boolean
  end
end
