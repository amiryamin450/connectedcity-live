class RemoveSomeFieldsMediaAttachments < ActiveRecord::Migration

  def up
    remove_column :media_attachments, :archive_id
    remove_column :media_attachments, :session_id
    remove_column :media_attachments, :stream_video_name
    remove_column :media_attachments, :has_audio
    remove_column :media_attachments, :has_video
    remove_column :media_attachments, :status
    remove_column :media_attachments, :stream_video_url
    remove_attachment :media_attachments, :stream_thumbnail
  end

  def down
    add_column :media_attachments, :archive_id, :string
    add_column :media_attachments, :session_id, :string
    add_column :media_attachments, :stream_video_name, :string
    add_column :media_attachments, :has_audio, :boolean, default: false
    add_column :media_attachments, :has_video, :boolean, default: false
    add_column :media_attachments, :status, :string
    add_column :media_attachments, :stream_video_url, :text
    add_attachment :media_attachments, :stream_thumbnail
  end
end
