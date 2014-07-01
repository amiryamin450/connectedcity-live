class AddPriceToServices < ActiveRecord::Migration
  def change
    add_column :services, :price, :decimal
  end
end
