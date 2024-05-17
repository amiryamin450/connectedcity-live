class AddRentalPropertyIdToRentalUnits < ActiveRecord::Migration[7.0]
  def change
    add_column :rental_units, :rental_property_id, :integer
  end
end
