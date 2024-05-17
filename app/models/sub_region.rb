# TODO: remove, no longer used
class SubRegion < ApplicationRecord

  belongs_to :region

  has_many :cities

  has_many :locations, through: :cities

  has_many :status_updates, -> { distinct }, through: :locations
  has_many :news_articles, -> { distinct }, through: :locations

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  has_attached_file :home_page_image, 
                    styles: {thumb: "100x100>"},
                    default_url: '/assets/home_page_image/:style/default.jpg'
end
