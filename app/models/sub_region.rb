# TODO: remove, no longer used
class SubRegion < ActiveRecord::Base

  belongs_to :region


  has_many :cities
  has_many :locations, through: :cities
  has_many :status_updates, through: :locations, uniq: true
  has_many :news_articles, through: :locations, uniq: true

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  has_attached_file :home_page_image, 
                    styles: {thumb: "100x100>"},
                    default_url: '/assets/home_page_image/:style/default.jpg'

  attr_accessible :description, :name, :region_id, :slug, :region, :home_page_image
end
