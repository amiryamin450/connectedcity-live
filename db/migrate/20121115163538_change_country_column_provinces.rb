class ChangeCountryColumnProvinces < ActiveRecord::Migration[7.0]
  def change
    rename_column :provinces, :country, :country_name
  end
end
