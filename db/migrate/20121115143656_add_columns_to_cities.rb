class AddColumnsToCities < ActiveRecord::Migration
  def change
    add_column :cities, :region_id, :integer
    add_column :cities, :sub_region_id, :integer
  end
end
