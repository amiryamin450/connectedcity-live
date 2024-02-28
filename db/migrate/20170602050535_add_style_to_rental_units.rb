class AddStyleToRentalUnits < ActiveRecord::Migration[7.0]
  def change
	add_column :rental_units, :style, :string
  end
end
