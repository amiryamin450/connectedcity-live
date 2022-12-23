class AddTokenToVideoCalls < ActiveRecord::Migration
  def change
    add_column :video_calls, :token, :string
  end
end
