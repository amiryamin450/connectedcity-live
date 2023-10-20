class Community < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  belongs_to :region
  has_many :cities
  has_many :locations, :through => :cities
  has_many :vertical_market_categories, :through => :locations

  validates_presence_of :name, :region_id
end
