class CreateTableVariant < ActiveRecord::Migration[7.0]
  def up
    create_table :variants do |t|
      t.integer :product_id
      t.string :name
      t.float :price
      t.string :sku
    end
  end

  def down
    drop_table :variants
  end
end
