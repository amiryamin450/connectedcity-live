class StatusUpdate < ActiveRecord::Base
  belongs_to :statusable, polymorphic: true
  belongs_to :district
  belongs_to :neighborhood
  belongs_to :city
  belongs_to :province

  # serialize :vertical_markets, Array
  # serialize :vertical_market_categories, Array

  default_scope order('created_at DESC')

  has_attached_file :image, :styles => { :thumb => "40x40#", :large => "320x>"},
                    :url => "/assets/status_update/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/status_update/:id/:style/:basename.:extension"

  attr_accessible :content, :provider, :district_id, :neighborhood_id, :latitude, :longitude, :city_id, :province_id,
                  :vertical_markets, :vertical_market_categories, :image

  validates_presence_of :content, message: "Content can't be blank"
  validates_length_of :content, maximum: 255
  validates_attachment_size :image, less_than: 3.megabytes
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/, message: "Please upload a valid image. Accepted types include jpg, png and gif."

  before_save do
    self.district_id = self.statusable.district_id
    self.neighborhood_id = self.statusable.neighborhood_id
    self.latitude = self.statusable.latitude
    self.longitude = self.statusable.longitude
    self.city_id = self.statusable.city_id
    self.province_id = self.statusable.province_id
    self.vertical_markets = self.statusable.vertical_markets.first.id if self.statusable.vertical_markets
    self.vertical_market_categories = self.statusable.vertical_market_categories.first.id if self.statusable.vertical_market_categories
  end

  # TODO Should this be done asynchronously?
  after_create do
    if statusable.respond_to?(:social_profiles) && statusable.social_profiles.any?
      statusable.social_profiles.each do |social_profile|
        # Twitter
        # Facebook
        case social_profile.social_network
        when :twitter
          require "twitter"

          begin
            client = Twitter::REST::Client.new do |config|
              config.consumer_key = "umyAJ3kCQf8WNWH2wywYKcXOS"
              config.consumer_secret = "ubK9hstQdIcbX6Ly2gXLAMQLU28dWJX4wwyMoNJ7GvEh0lVRl9"
              config.access_token = social_profile.access_token
              config.access_token_secret = social_profile.access_token_secret
            end

            if image.present? && image.is_a?(Paperclip::Attachment)
              client.update_with_media content, image.path
            else
              client.update content
            end
          rescue
          end
        when :facebook
          require "koala"

          begin
            api = Koala::Facebook::API.new social_profile.access_token

            if image.present? && image.is_a?(Paperclip::Attachment)
              api.put_picture image.path, image.content_type, message: content
            else
              api.put_wall_post content
            end
          rescue
          end
        end
      end
    end
  end
end
