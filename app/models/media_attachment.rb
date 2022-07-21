class MediaAttachment < ActiveRecord::Base

  before_save :set_fields, :unless => :stream_video?

  belongs_to :attachable, polymorphic: true
  belongs_to :location, foreign_key: "attachable_id"
  belongs_to :category
  has_many :videos, dependent: :destroy

  attr_accessible :attachable_id, :attachable_type, :attachment, :attachment_html, :title, :thumb_url, :media_source_id, :media_source, :is_stream_video, :archive_id, :session_id, :description, :is_draft, :category_id

  validates_presence_of :attachment, :unless => :stream_video?

  default_scope where(is_draft: false)

  def thumbnail_url style=:original
    if self.is_stream_video
      self.videos.first&.thumbnail&.file? ? self.videos.first.thumbnail.url(style) : "/assets/home_page_image/default.jpg"
    else
      self.thumb_url
    end
  end

  def stream_video?
    self.is_stream_video
  end

  def geo_location
    if latitude.blank? || longitude.blank?
      {:lat => self.location.latitude, :long => self.location.longitude}
    else
      {:lat => latitude, :long => longitude}
    end
  end

  protected
  def set_fields
    regex = /https?:\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\S)*/
    youtube_id = attachment.scan(regex)[0][2]

    # TODO: handle failure case for the call below
    self.title = JSON.load(open("https://www.googleapis.com/youtube/v3/videos?id=#{youtube_id}&key=#{ENV['GOOGLE_API_KEY']}&part=snippet"))['items'][0]['snippet']['title']
    self.thumb_url = "https://img.youtube.com/vi/#{youtube_id}/0.jpg"
    self.media_source = 'youtube'
    self.media_source_id = youtube_id
    self.attachment_html = "<iframe width='853' height='480' src='http://www.youtube.com/embed/#{youtube_id}' frameborder='0' allowfullscreen></iframe>"
  end

end
