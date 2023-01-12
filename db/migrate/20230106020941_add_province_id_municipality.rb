class AddProvinceIdMunicipality < ActiveRecord::Migration
  def up
    add_column :municipalities, :province_id, :integer
  end

  def down
    remove_column :municipalities, :province_id
  end
end
