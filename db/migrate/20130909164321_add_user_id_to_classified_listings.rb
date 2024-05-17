class AddUserIdToClassifiedListings < ActiveRecord::Migration[7.0]
  def change
    add_column :classified_listings, :user_id, :integer
  end
end
