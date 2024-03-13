class AddShipments < ActiveRecord::Migration[7.0]
  def change
    create_table :shipments do |t|
      t.string :tracking_number
      t.integer :status, default: 0
      t.integer :delivery_method, default: 0
      t.string :shipping_name
      t.json :shipping_address
      t.datetime :shipped_at
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end