class CreateLocationImages < ActiveRecord::Migration
  def change
    create_table :location_images do |t|
      t.string :caption
      t.integer :location_id

      t.timestamps
    end
  end
end
