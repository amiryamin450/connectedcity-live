class Municipality < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  belongs_to :region
  has_many :cities

  attr_accessible :name, :municipality_code
end
