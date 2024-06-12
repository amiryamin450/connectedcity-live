class AddCitizenIdToLocations < ActiveRecord::Migration[7.0]
  def change
    add_reference :locations, :user, null: true
  end
end
