class AddBroadcastIdToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :broadcast_id, :string
  end
end
