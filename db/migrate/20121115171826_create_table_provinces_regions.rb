class CreateTableProvincesRegions < ActiveRecord::Migration[7.0]
  def change
    create_table :provinces_regions, :id =>false do |t|
      t.integer :region_id
      t.integer :province_id
    end
  end
end
