class AddStylesToRentalProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :rental_properties, :style, :string
  end
end
