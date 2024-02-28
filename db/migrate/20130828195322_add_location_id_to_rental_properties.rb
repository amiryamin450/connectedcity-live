class AddLocationIdToRentalProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :rental_properties, :location_id, :integer
  end
end
