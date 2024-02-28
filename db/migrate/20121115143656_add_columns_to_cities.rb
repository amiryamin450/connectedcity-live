class AddColumnsToCities < ActiveRecord::Migration[7.0]
  def change
    add_column :cities, :region_id, :integer
    add_column :cities, :sub_region_id, :integer
  end
end
