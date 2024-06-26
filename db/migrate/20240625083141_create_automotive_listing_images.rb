class CreateAutomotiveListingImages < ActiveRecord::Migration[7.0]
  def change
    create_table :automotive_listing_images do |t|
      t.references :automotive_listing
      t.integer :image_type
      t.attachment :image

      t.timestamps
    end
  end
end
