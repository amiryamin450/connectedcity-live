class CreateStatusUpdates < ActiveRecord::Migration
  def change
    create_table :status_updates do |t|
      t.string :title
      t.string :content
      t.string :provider
      t.integer :location_id

      t.timestamps
    end
  end
end
