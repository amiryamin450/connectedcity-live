class AddOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :number
      t.integer :status, default: 0
      t.string :payment_method
      t.datetime :confirmed_ready_at
      t.references :customer, null: false#, foreign_key: true
      t.references :seller, null: false#, foreign_key: true

      t.timestamps
    end
  end
end