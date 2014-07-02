class Brand < ActiveRecord::Base

  has_and_belongs_to_many :locations

  has_many :status_updates, as: :statusable, dependent: :destroy
  has_many :news_articles, as: :newsable, dependent: :destroy
  has_many :location_status_updates, through: :locations, source: :status_updates, uniq: true

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  attr_accessible :description, :name, :slug, :logo, :website_url, :status_updates_attributes, :home_page_image

  has_attached_file :logo, :styles => { thumb: "50x50", list: "270", display: "270" },
  :url => "/system/brands/logo/:id/:style/:basename.:extension",
  :path => ":rails_root/public/system/brands/logo/:id/:style/:basename.:extension",
  :default_url => "http://placehold.it/268x151"
  has_attached_file :home_page_image, :styles => { :thumb => "100x178", :home_page => "1650" },
  url: "/system/brands/home_page_image/:id/:style/:basename.:extension",
  path: ":rails_root/public/system/brands/home_page_image/:id/:style/:basename.:extension",
  default_url: '/assets/home_page_image/default.jpg'


  accepts_nested_attributes_for :status_updates, allow_destroy: true
  accepts_nested_attributes_for :news_articles, allow_destroy: true

  def status_updates_all
    status_updates + location_status_updates
  end


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
