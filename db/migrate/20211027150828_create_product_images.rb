class CreateProductImages < ActiveRecord::Migration
  def change
    create_table :product_images do |t|
      t.belongs_to :product
      t.attachment :image

      t.timestamps
    end
    
    add_index :product_images, :product_id
  end
end
