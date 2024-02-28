class CreateTableLocationUser < ActiveRecord::Migration[7.0]
  def change
    create_table :locations_users, id: false do |t|
      t.integer :location_id, null: false
      t.integer :user_id, null: false
    end
  end
end
