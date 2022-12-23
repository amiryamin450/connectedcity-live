class ChangeTokenToVideoCalls < ActiveRecord::Migration
  def up
    change_column(:video_calls, :token, :text)
  end

  def down
  end
end
