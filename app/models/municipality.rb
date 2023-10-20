class Municipality < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  belongs_to :region
  belongs_to :province
  has_many :cities
  has_many :districts, through: :cities
  has_many :neighborhoods, through: :districts
  has_many :sub_neighborhoods, through: :neighborhoods
  has_many :locations

  has_many :coupons, -> { distinct }, through: :locations
  has_many :services, -> { distinct }, through: :locations
  has_many :products, -> { distinct }, through: :locations
  has_many :media_attachments, -> { distinct }, through: :locations
  has_many :blog_entries, -> { distinct }, through: :locations
  has_many :status_updates, -> { distinct },through: :locations
  has_many :news_articles, -> { distinct }, through: :locations
  has_many :events, -> { distinct }, through: :locations

  def access_link
    "#{region.access_link}/#{slug}"
  end
end
