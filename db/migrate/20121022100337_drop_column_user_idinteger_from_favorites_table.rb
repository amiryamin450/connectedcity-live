class DropColumnUserIdintegerFromFavoritesTable < ActiveRecord::Migration
  def change
    remove_column :favorites, :user_idinteger
  end
end
