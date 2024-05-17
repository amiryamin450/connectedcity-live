class AddIsActiveToCities < ActiveRecord::Migration[7.0]
  def change
    add_column :maponics_subdivisions, :is_active, :boolean, default: false
  end
end
