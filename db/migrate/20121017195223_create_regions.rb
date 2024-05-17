class CreateRegions < ActiveRecord::Migration[7.0]
  def change
    create_table :regions do |t|
      t.string :name
      t.integer :state_or_province_id

      t.timestamps
    end
  end
end
