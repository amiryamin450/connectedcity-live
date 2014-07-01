class AddShowInMenuToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :show_in_menu, :boolean
  end
end
