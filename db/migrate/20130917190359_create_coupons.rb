class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :name
      t.text :description
      t.date :expiration
      t.integer :howmany
      t.integer :redemptions_count, :default => 0

      t.timestamps
    end
  end
end
