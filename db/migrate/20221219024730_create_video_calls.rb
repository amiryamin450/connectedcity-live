class CreateVideoCalls < ActiveRecord::Migration[7.0]
  def up
    create_table :video_calls do |t|
      t.string :session_id
      t.integer :user_business_id
      t.string :user_call_id
      t.string :status, default: "available"
    end
  end

  def down
    drop_table :video_calls
  end
end
