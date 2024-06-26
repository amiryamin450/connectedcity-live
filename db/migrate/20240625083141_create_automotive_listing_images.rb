class CreateAutomotiveListingImages < ActiveRecord::Migration[7.0]
  def change
    create_table :automotive_listing_images do |t|
      t.references :main, index: true, foreign_key: { to_table: :automotive_listings }, type: :integer
      t.references :sub, index: true, foreign_key: { to_table: :automotive_listings }, type: :integer
      t.attachment :image

      t.timestamps
    end
  end
end
