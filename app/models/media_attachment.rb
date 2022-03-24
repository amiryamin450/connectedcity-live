class MediaAttachment < ActiveRecord::Base

  before_save :set_fields, :unless => :stream_video?

  belongs_to :attachable, polymorphic: true
  belongs_to :location, foreign_key: "attachable_id", conditions: { media_attachments: { attachable_type: "Location" } }

  attr_accessible :attachable_id, :attachable_type, :attachment, :attachment_html, :title, :thumb_url, :media_source_id, :media_source, :is_stream_video, :archive_id, :session_id, :stream_video_name, :has_audio, :has_video, :status, :description

  validates_presence_of :attachment, :unless => :stream_video?

  has_attached_file :stream_thumbnail, :styles => { :thumb => "320x180", :original => "480x360" },
    :url => "/system/media_attachment/stream_thumbnail/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/media_attachment/stream_thumbnail/:id/:style/:basename.:extension"

  def media_title
    self.is_stream_video ? self.stream_video_name : self.title
  end

  def thumbnail_url style=:original
    if self.is_stream_video
      self.stream_thumbnail.file? ? self.stream_thumbnail.url(style) : "/assets/home_page_image/default.jpg"
    else
      self.thumb_url
    end
  end

  def stream_video?
    self.is_stream_video
  end

  protected
  def set_fields
    regex = /https?:\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\S)*/
    youtube_id = attachment.scan(regex)[0][2]

    # TODO: handle failure case for the call below
    self.title = JSON.load(open("https://www.googleapis.com/youtube/v3/videos?id=#{youtube_id}&key=#{Settings.google_api_key}&part=snippet"))['items'][0]['snippet']['title']
    self.thumb_url = "https://img.youtube.com/vi/#{youtube_id}/0.jpg"
    self.media_source = 'youtube'
    self.media_source_id = youtube_id
    self.attachment_html = "<iframe width='853' height='480' src='http://www.youtube.com/embed/#{youtube_id}' frameborder='0' allowfullscreen></iframe>"
  end

end
