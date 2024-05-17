class AddFieldsToStatusUpdates < ActiveRecord::Migration[7.0]
  def change
    add_column :status_updates, :district_id, :integer
    add_column :status_updates, :neighborhood_id, :integer
    add_column :status_updates, :latitude, :float
    add_column :status_updates, :longitude, :float
    add_column :status_updates, :city_id, :integer
    add_column :status_updates, :province_id, :integer
    add_column :status_updates, :vertical_markets, :string
    add_column :status_updates, :vertical_market_categories, :string
  end
end
