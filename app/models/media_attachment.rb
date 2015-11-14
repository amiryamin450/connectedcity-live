class MediaAttachment < ActiveRecord::Base

  before_save :set_fields

  belongs_to :attachable, polymorphic: true
  belongs_to :location, foreign_key: "attachable_id", conditions: { media_attachments: { attachable_type: "Location" } }

  attr_accessible :attachable_id, :attachable_type, :attachment, :attachment_html, :title, :thumb_url, :media_source_id, :media_source


  validates_presence_of :attachment

  def self.find_by_locations(locations, limit = 10)
    # TODO Remove me
    locations = Location.where city_id: 5915022
    # locations = locations.where district_id: district.id if district
    # locations = locations.where neighborhood_id: neighborhood.id if neighborhood

    # SELECT `vertical_market_categories`.* FROM `vertical_market_categories`  WHERE `vertical_market_categories`.`vertical_market_id` IN (3) AND (locations.city_id = 5915022)

    where(attachable: locations).limit(limit)

    # 2 steps:
    # - find all locations
    # - find media attachments for that location
    #
    # MediaAttachment.where(attachable_type: "Location")
  end

  protected
  def set_fields
    regex = /https?:\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\S)*/
    youtube_id = attachment.scan(regex)[0][2]

    # TODO: handle failure case for the call below
    self.title = JSON.load(open("https://www.googleapis.com/youtube/v3/videos?id=#{youtube_id}&key=AIzaSyBV89A5AI8esypRl9M-znIiYQ0Zkl-ldyg&part=snippet"))['items'][0]['snippet']['title']
    self.thumb_url = "http://img.youtube.com/vi/#{youtube_id}/0.jpg"
    self.media_source = 'youtube'
    self.media_source_id = youtube_id
    self.attachment_html = "<iframe width='853' height='480' src='http://www.youtube.com/embed/#{youtube_id}' frameborder='0' allowfullscreen></iframe>"
  end

end
