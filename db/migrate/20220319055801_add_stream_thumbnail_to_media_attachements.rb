class AddStreamThumbnailToMediaAttachements < ActiveRecord::Migration
  def self.up
    change_table :media_attachments do |t|
      t.has_attached_file :stream_thumbnail
    end
  end

  def self.down
    drop_attached_file :media_attachments, :stream_thumbnail
  end
end
