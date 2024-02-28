class CreateSubRegions < ActiveRecord::Migration[7.0]
  def change
    create_table :sub_regions do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.integer :region_id

      t.timestamps
    end
  end
end
