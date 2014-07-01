class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :email
      t.string :url
      t.references :location

      t.timestamps
    end
    add_index :events, :location_id
  end
end
