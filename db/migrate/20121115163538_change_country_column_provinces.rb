class ChangeCountryColumnProvinces < ActiveRecord::Migration
  def change
    rename_column :provinces, :country, :country_name
  end
end
