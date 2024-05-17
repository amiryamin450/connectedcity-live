class AddStripeAccountIdToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :stripe_account_id, :string
  end
end
