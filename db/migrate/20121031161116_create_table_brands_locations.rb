class CreateTableBrandsLocations < ActiveRecord::Migration[7.0]
  def up
    create_table :brands_locations, :id =>false do |t|
      t.integer :brand_id
      t.integer :location_id
    end
  end

  def down
    drop_table :brands_locations
  end
end
