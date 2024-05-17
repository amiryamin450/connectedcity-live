class AddSomeVonageVideoFieldsToMediaAttachment < ActiveRecord::Migration[7.0]
  def change
    add_column :media_attachments, :is_stream_video, :boolean, default: false
    add_column :media_attachments, :archive_id, :string
    add_column :media_attachments, :session_id, :string
    add_column :media_attachments, :stream_video_name, :string
    add_column :media_attachments, :has_audio, :boolean, default: false
    add_column :media_attachments, :has_video, :boolean, default: false
    add_column :media_attachments, :status, :string
    add_column :media_attachments, :stream_video_url, :text
  end
end
