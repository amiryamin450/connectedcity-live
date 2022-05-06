class Video < ActiveRecord::Base
  belongs_to :media_attachment
  accepts_nested_attributes_for :media_attachment

  attr_accessible :archive_id, :session_id, :stream_video_name, :has_audio, :has_video, :status, :timestamp_thumbnail, :resolution, :frame_rate, :livestream, :media_attachment_id, :video_url, :media_attachments_attributes

  has_attached_file :thumbnail, :styles => { :thumb => "320x180", :original => "480x360" },
    :url => "/system/video/thumbnail/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/video/thumbnail/:id/:style/:basename.:extension"
end
