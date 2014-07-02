class AddLocationIdToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :location_id, :integer
    add_column :coupons, :code_prefix, :string
  end
end
