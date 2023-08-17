# TODO: remove, no longer used
class Region < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  belongs_to :province
  has_many :municipalities
  # has_and_belongs_to_many :provinces

  # has_many :cities
  # has_many :sub_regions
  # has_many :districts, through: :cities
  # has_many :locations, through: :cities
  # has_many :status_updates, through: :locations, uniq: true
  # has_many :news_articles, through: :locations, uniq: true


  attr_accessible :name, :region_code, :slug, :province_id, :show_in_menu, :subdomain
  # has_attached_file :home_page_image, styles: {thumb: "100x100>"}, default_url: '/assets/home_page_image/:style/default.jpg'
  # validates_presence_of :name, :region_code

  def access_link
    "/#{province.slug}/#{slug}"
  end
end
