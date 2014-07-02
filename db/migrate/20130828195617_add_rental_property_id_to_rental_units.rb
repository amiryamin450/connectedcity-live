class AddRentalPropertyIdToRentalUnits < ActiveRecord::Migration
  def change
    add_column :rental_units, :rental_property_id, :integer
  end
end
