class Event < ApplicationRecord
  belongs_to :location
  belongs_to :category

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  default_scope { where("ends_at > ?", Time.now) }

  scope :store_event, -> {
    where("ends_at > ?", Time.now - 180.days)
  }
  validates_presence_of :ends_at, :starts_at
  validates :name, presence: true, length: { in: 1..100 }
  validates :description, presence: true, length: { in: 1..3000 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, length: { in: 1..300 }

  has_attached_file :image, styles: {
    thumb: "150x150#", list: "320x200#"
  }

  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "description", "email", "ends_at", "id", "image_content_type", "image_file_name", "image_file_size", "image_updated_at", "latitude", "location_id", "longitude", "name", "slug", "starts_at", "updated_at", "url"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "location"]
  end

  def geo_location
    if latitude.blank? || longitude.blank?
      {:lat => self.location.latitude, :long => self.location.longitude}
    else
      {:lat => latitude, :long => longitude}
    end
  end
end
