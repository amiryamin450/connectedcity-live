class StatusUpdate < ApplicationRecord
  belongs_to :statusable, polymorphic: true

  belongs_to :location, foreign_key: "statusable_id"
  # belongs_to :location, -> { joins(:status_updates).where(status_updates: { statusable_type: "Location" }) }, foreign_key: "statusable_id"
  belongs_to :district
  belongs_to :neighborhood
  belongs_to :city
  belongs_to :province
  belongs_to :category

  default_scope { order('created_at DESC') }

  has_attached_file :image, :styles => { :thumb => "40x40#", :large => "320x>"},
                    :url => "/system/status_update/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/status_update/:id/:style/:basename.:extension"

  validates_attachment_presence :image

  attr_accessor :social_profile_ids

  validates :content, presence: true, length: { in: 1..1500 }

  validates_attachment_size :image, less_than: 5.megabytes
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/, message: "Please upload a valid image. Accepted types include jpg, png."

  before_save do
    if self.statusable
      self.district_id = self.statusable.district_id
      self.neighborhood_id = self.statusable.neighborhood_id
      self.city_id = self.statusable.city_id
      self.province_id = self.statusable.province_id
      self.vertical_markets = self.statusable.vertical_markets.first.id if self.statusable.vertical_markets
      self.vertical_market_categories = self.statusable.vertical_market_categories.first.id if self.statusable.vertical_market_categories
    end
  end

  def geo_location
    {:lat => latitude, :long => longitude}
  end

  # TODO Should this be done asynchronously?
  def push
    return if social_profile_ids.nil? || social_profile_ids.empty?

    if statusable.respond_to?(:social_profiles) && statusable.social_profiles.any?
      statusable.social_profiles.each do |social_profile|
        next unless social_profile_ids.include?(social_profile.id.to_s)

        case social_profile.social_network
        when :twitter
          begin
            client = Twitter::REST::Client.new do |config|
              config.consumer_key = Settings.twitter_consumer_key
              config.consumer_secret = Settings.twitter_consumer_secret
              config.access_token = social_profile.access_token
              config.access_token_secret = social_profile.access_token_secret
            end

            if image.present? && image.is_a?(Paperclip::Attachment)
              client.update_with_media content, open(image.path)
            else
              client.update content
            end
          rescue
          end
        when :facebook
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
  after_create :push

  def statusable_v2
    statusable || Location.unscoped.find(statusable_id)
  end
end
