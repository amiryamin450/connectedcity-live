class Community < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  belongs_to :region
  has_many :cities
  has_many :locations, :through => :cities
  has_many :vertical_market_categories, :through => :locations

  attr_accessible :description, :name, :region_id

  validates_presence_of :name, :region_id



end
