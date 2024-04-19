class AddActiveToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :active, :boolean, default: true
  end
end
