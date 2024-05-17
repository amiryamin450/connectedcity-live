class AddSuperAdminToLocation < ActiveRecord::Migration[7.0]
  def change
    add_reference :locations, :super_admin, null: true, foreign_key: false
  end
end
