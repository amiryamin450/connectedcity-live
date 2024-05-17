class ChangeColumnsCities < ActiveRecord::Migration[7.0]
  def change
    add_column :cities, :region_code, :integer
  end
end