class Event < ActiveRecord::Base
  belongs_to :location
  belongs_to :category

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  attr_accessible :description, :email, :ends_at, :name, :starts_at, :url, :slug, :location_id, :image, :category_id, :latitude, :longitude

  default_scope where("ends_at > ?", Time.now)
  scope :store_event, -> {
    where("ends_at > ?", Time.now - 180.days)
  }
  validates_presence_of :ends_at, :starts_at
  validates :name, presence: true, length: { in: 1..100 }
  validates :description, presence: true, length: { in: 1..1500 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, length: { in: 1..300 }

  has_attached_file :image, styles: {
    thumb: "150x150#", list: "320x200#"
  }

  def geo_location
    if latitude.blank? || longitude.blank?
      {:lat => self.location.latitude, :long => self.location.longitude}
    else
      {:lat => latitude, :long => longitude}
    end
  end
end
