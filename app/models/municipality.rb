class Municipality < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  belongs_to :region

  attr_accessible :name, :municipality_code
end
