class ChangeColumnsCities < ActiveRecord::Migration
  def change
    add_column :cities, :region_code, :integer
  end
end