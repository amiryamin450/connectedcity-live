class AddStripeAccountIdToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :stripe_account_id, :string
  end
end
