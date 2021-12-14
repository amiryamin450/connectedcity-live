class District < ActiveRecord::Base
  belongs_to :city

  has_many :locations
  has_many :neighborhoods
  has_many :business_improvement_areas

  has_many :status_updates
  has_many :news_articles, through: :locations, uniq: true
  has_many :media_attachments, through: :locations, uniq: true
  has_many :events, through: :locations, uniq: true
  has_many :carousel_images, as: :carouselable
  has_many :city_news_articles

  has_many :coupons, through: :locations, uniq: true
  has_many :services, through: :locations, uniq: true
  has_many :products, through: :locations, uniq: true
  has_many :blog_entries, through: :locations, uniq: true

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  has_attached_file :home_page_image, styles: {thumb: "100x100>", :cover => "1500>x429", :home_page => "1650" },
                    default_url: '/assets/home_page_image/default.jpg'

  attr_accessible :city_id, :description, :name, :slug, :city, :home_page_image, :use_carousel




end
