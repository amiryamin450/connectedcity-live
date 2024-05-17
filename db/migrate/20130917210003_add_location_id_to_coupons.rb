class AddLocationIdToCoupons < ActiveRecord::Migration[7.0]
  def change
    add_column :coupons, :location_id, :integer
    add_column :coupons, :code_prefix, :string
  end
end
