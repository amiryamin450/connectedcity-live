class AddContentToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :content, :text
  end
end
