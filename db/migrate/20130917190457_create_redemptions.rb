class CreateRedemptions < ActiveRecord::Migration
  def change
    create_table :redemptions do |t|
      t.integer :coupon_id
      t.integer :user_id
      t.string :transaction_id

      t.timestamps
    end
  end
end
