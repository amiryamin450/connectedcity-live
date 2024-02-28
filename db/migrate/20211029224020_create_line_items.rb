class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.references :product
      t.belongs_to :cart
      t.integer :quantity, default: 1

      t.timestamps
    end
    add_index :line_items, :product_id
    add_index :line_items, :cart_id
  end
end
