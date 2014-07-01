class AddContentToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :content, :text
  end
end
