class Municipality < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  belongs_to :region
  belongs_to :province
  has_many :cities
  has_many :districts, through: :cities
  has_many :neighborhoods, through: :districts
  has_many :sub_neighborhoods, through: :neighborhoods
  has_many :locations

  has_many :coupons, through: :locations, uniq: true
  has_many :services, through: :locations, uniq: true
  has_many :products, through: :locations, uniq: true
  has_many :media_attachments, through: :locations, uniq: true
  has_many :blog_entries, through: :locations, uniq: true
  has_many :status_updates,through: :locations, uniq: true
  has_many :news_articles, through: :locations, uniq: true
  has_many :events, through: :locations, uniq: true

  attr_accessible :name, :municipality_code

  def access_link
    "#{region.access_link}/#{slug}"
  end
end


# Location.all.each do |lo|
#   lo.update_attribute(:municipality_id, lo.city&.municipality_id)
# end