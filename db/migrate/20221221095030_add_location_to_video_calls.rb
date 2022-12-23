class AddLocationToVideoCalls < ActiveRecord::Migration
  def change
    add_column :video_calls, :location_id, :integer
  end
end
