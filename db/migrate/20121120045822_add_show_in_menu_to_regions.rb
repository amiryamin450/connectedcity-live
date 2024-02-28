class AddShowInMenuToRegions < ActiveRecord::Migration[7.0]
  def change
    add_column :regions, :show_in_menu, :boolean
  end
end
