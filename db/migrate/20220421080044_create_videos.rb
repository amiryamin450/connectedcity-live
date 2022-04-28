class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.has_attached_file :thumbnail
      t.text :video_url
      t.string :status
      t.datetime :timestamp_thumbnail
      t.boolean :updated_audio, default: false
      t.string :resolution
      t.string :frame_rate
      t.string :session_id
      t.string :archive_id
      t.boolean :has_audio
      t.boolean :has_video
      t.boolean :livestream, default: false
      t.references :media_attachment

      t.timestamps
    end
  end
end
