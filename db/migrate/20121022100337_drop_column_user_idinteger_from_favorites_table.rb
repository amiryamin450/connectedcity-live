class DropColumnUserIdintegerFromFavoritesTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :favorites, :user_idinteger
  end
end
