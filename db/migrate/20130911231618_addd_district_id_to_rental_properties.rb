class AdddDistrictIdToRentalProperties < ActiveRecord::Migration
  def up
    add_column :rental_properties, :district_id, :integer
  end

  def down
    remove_column :rental_properties, :district_id
  end
end
