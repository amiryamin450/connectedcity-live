class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.string :user_idinteger
      t.integer :location_id
      t.string :category

      t.timestamps
    end
  end
end
