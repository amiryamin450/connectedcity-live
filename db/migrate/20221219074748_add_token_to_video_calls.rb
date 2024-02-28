class AddTokenToVideoCalls < ActiveRecord::Migration[7.0]
  def change
    add_column :video_calls, :token, :string
  end
end
