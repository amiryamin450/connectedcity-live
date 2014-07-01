class District < ActiveRecord::Base
  belongs_to :city

  has_many :locations

  has_many :status_updates, through: :locations, uniq: true
  has_many :news_articles, through: :locations, uniq: true

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  has_attached_file :home_page_image, styles: {thumb: "100x100>"},
                    default_url: '/assets/home_page_image/default.jpg'

  attr_accessible :city_id, :description, :name, :slug, :city, :home_page_image
end
