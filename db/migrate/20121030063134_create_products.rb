class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku
      t.text :description
      t.decimal :price
      t.string :slug
      t.references :location

      t.timestamps
    end
    add_index :products, :location_id
  end
end
