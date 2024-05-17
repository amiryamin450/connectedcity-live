class AddColumnsToProvinces < ActiveRecord::Migration[7.0]
  def change
    add_column :provinces, :country_code, :string
    add_column :provinces, :country, :string
    add_column :provinces, :province_code, :string
  end
end
