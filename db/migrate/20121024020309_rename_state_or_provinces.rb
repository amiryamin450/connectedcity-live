class RenameStateOrProvinces < ActiveRecord::Migration
  def up
    rename_table :state_or_provinces, :provinces
  end

  def down
    rename_table :provinces, :state_or_provinces
  end
end
