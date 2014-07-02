class AddLocationIdToRentalProperties < ActiveRecord::Migration
  def change
    add_column :rental_properties, :location_id, :integer
  end
end
