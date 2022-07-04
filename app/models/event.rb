class Event < ActiveRecord::Base
  belongs_to :location
  belongs_to :category

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  attr_accessible :description, :email, :ends_at, :name, :starts_at, :url, :slug, :location_id, :image, :category_id

  default_scope where("ends_at > ?", Time.now)

  validates_presence_of :description, :email, :ends_at, :name, :starts_at

  has_attached_file :image, styles: {
    thumb: "150x150#", list: "320x200#"
  }
end
