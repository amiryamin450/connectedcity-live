class MediaAttachment < ActiveRecord::Base

  before_save :set_fields

  belongs_to :attachable, polymorphic: true
  belongs_to :location, foreign_key: "attachable_id", conditions: { media_attachments: { attachable_type: "Location" } }

  attr_accessible :attachable_id, :attachable_type, :attachment, :attachment_html, :title, :thumb_url, :media_source_id, :media_source


  validates_presence_of :attachment

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
