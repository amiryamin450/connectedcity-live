class CreateOperatingHours < ActiveRecord::Migration[7.0]
  def change
    create_table :operating_hours do |t|
      t.integer :day, null: false

      t.time :starts_at
      t.time :ends_at

      t.boolean :closed, default: false

      t.references :location, null: false, index: true

      t.timestamps
    end
  end
end
