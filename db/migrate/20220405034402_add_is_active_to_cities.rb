class AddIsActiveToCities < ActiveRecord::Migration
  def change
    add_column :maponics_subdivisions, :is_active, :boolean, default: false
  end
end
