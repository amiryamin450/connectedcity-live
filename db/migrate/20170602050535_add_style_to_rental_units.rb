class AddStyleToRentalUnits < ActiveRecord::Migration
  def change
	add_column :rental_units, :style, :string
  end
end
