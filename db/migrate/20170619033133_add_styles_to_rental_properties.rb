class AddStylesToRentalProperties < ActiveRecord::Migration
  def change
    add_column :rental_properties, :style, :string
  end
end
