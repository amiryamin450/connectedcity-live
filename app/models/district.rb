class District < ApplicationRecord
  belongs_to :city

  has_many :locations
  has_many :neighborhoods
  has_many :business_improvement_areas

  has_many :status_updates
  has_many :news_articles, -> { distinct }, through: :locations
  has_many :media_attachments, -> { distinct }, through: :locations
  has_many :events, -> { distinct }, through: :locations
  has_many :carousel_images, as: :carouselable
  has_many :city_news_articles

  has_many :coupons, -> { distinct }, through: :locations
  has_many :services, -> { distinct }, through: :locations
  has_many :products, -> { distinct }, through: :locations
  has_many :blog_entries, -> { distinct }, through: :locations

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  has_attached_file :home_page_image, styles: {thumb: "100x100>", :cover => "1500>x429", :home_page => "1650" },
                    default_url: '/assets/home_page_image/default.jpg'


  def access_link
    "#{city.access_link}/#{slug}"
  end
end
