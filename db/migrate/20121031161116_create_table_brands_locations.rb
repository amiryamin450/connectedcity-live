class CreateTableBrandsLocations < ActiveRecord::Migration
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
