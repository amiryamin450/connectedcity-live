class ChangeTokenToVideoCalls < ActiveRecord::Migration[7.0]
  def up
    change_column(:video_calls, :token, :text)
  end

  def down
  end
end
