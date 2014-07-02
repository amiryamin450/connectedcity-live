class AddUserIdToClassifiedListings < ActiveRecord::Migration
  def change
    add_column :classified_listings, :user_id, :integer
  end
end
