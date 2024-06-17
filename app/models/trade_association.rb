class TradeAssociation < ApplicationRecord
  extend FriendlyId

  belongs_to :city
  belongs_to :province

  has_many :status_updates, as: :statusable, dependent: :destroy
  has_many :news_articles, as: :newsable, dependent: :destroy
  has_and_belongs_to_many :locations
  has_many :location_status_updates, -> { distinct }, through: :locations, source: :status_updates
  has_many :location_events, -> { distinct }, through: :locations, source: :events

  accepts_nested_attributes_for :status_updates, allow_destroy: true
  accepts_nested_attributes_for :news_articles, allow_destroy: true

  friendly_id :name, use: [:slugged, :history]

  has_attached_file :home_page_image, :styles => { :thumb => "100x178" },
    url: "/system/ta/home_page_image/:id/:style/:basename.:extension",
    path: ":rails_root/public/system/ta/home_page_image/:id/:style/:basename.:extension",
    default_url: '/assets/home_page_image/default.jpg'

  has_attached_file :logo, :styles => { :thumb => "70x55", list: "240x141#", display: "270" },
    url: "/system/ta/logo/:id/:style/:basename.:extension",
    path: ":rails_root/public/system/ta/logo/:id/:style/:basename.:extension",
    default_url: "/system/logo_missing.png"

  validates_presence_of :city, :province, :name

  def district_id
    nil
  end

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

  def vertical_markets
    nil
  end

  def vertical_market_categories
    nil
  end
end
