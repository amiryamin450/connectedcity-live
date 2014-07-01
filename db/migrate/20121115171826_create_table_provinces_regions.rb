class CreateTableProvincesRegions < ActiveRecord::Migration
  def change
    create_table :provinces_regions, :id =>false do |t|
      t.integer :region_id
      t.integer :province_id
    end
  end
end
