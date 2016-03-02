class CreateLocationMenus < ActiveRecord::Migration
  def change
    create_table :location_menus do |t|
      t.string :caption
      t.integer :location_id
      t.has_attached_file :image

      t.timestamps
    end
  end
end
