class AddBroadcastIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :broadcast_id, :string
  end
end
