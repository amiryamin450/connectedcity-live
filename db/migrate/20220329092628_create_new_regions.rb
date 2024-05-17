class CreateNewRegions < ActiveRecord::Migration[7.0]
  def change
    create_table :regions do |t|
      t.string :name
      t.string :slug
      t.string :region_code
      t.string :subdomain
      t.integer :province_id
      t.boolean :show_in_menu

      t.timestamps
    end
  end
end
