class BusinessImprovementArea < ApplicationRecord
  extend FriendlyId

  acts_as_messageable

  default_scope { order(:name) }

  belongs_to :district
  belongs_to :user
  has_many :status_updates, as: :statusable, dependent: :destroy

  has_many :locations
  has_many :carousel_images, as: :carouselable

  has_many :location_status_updates, -> { distinct }, through: :locations, source: :status_updates
  has_many :events, -> { distinct }, through: :locations
  has_many :vertical_markets, -> { distinct }, through: :locations
  has_many :vertical_market_categories, -> { distinct }, through: :locations
  has_many :news_articles, -> { distinct }, through: :locations
  has_many :media_attachments, -> { distinct }, through: :locations
  has_many :coupons, -> { distinct }, through: :locations
  has_many :services, -> { distinct }, through: :locations
  has_many :products, -> { distinct }, through: :locations
  has_many :blog_entries, -> { distinct }, through: :locations

  accepts_nested_attributes_for :status_updates, allow_destroy: true
  accepts_nested_attributes_for :news_articles, allow_destroy: true

  friendly_id :name, use: [:slugged, :history]

  def neighborhood_id
    nil
  end

  def latitude
    nil
  end

  def longitude
    nil
  end

  def city_id
    nil
  end

  def province_id
    nil
  end

  has_attached_file :home_page_image, :styles => { :thumb => "100x178" },
    url: "/system/bia/home_page_image/:id/:style/:basename.:extension",
    path: ":rails_root/public/system/bia/home_page_image/:id/:style/:basename.:extension",
    default_url: '/assets/home_page_image/default.jpg'

  has_attached_file :logo, :styles => { :thumb => "70x55", list: "250x100", display: "250" },
    url: "/system/bia/logo/:id/:style/:basename.:extension",
    path: ":rails_root/public/system/bia/logo/:id/:style/:basename.:extension",
    default_url: "/system/bia/logo/missing.png"

  validates_presence_of :district, :name

  def all_status_updates
    locations_ids = locations.pluck(:id) + [0]
    StatusUpdate.where("(statusable_type = 'Location' AND statusable_id IN (:locations_ids)) OR (statusable_type = 'BusinessImprovementArea' AND statusable_id = :bia_id)", locations_ids: locations_ids, bia_id: id).includes(statusable: :vertical_market_categories)
  end
end
