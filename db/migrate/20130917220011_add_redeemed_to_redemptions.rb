class AddRedeemedToRedemptions < ActiveRecord::Migration
  def change
    add_column :redemptions, :redeemed, :boolean
  end
end
