class ClassifiedCategory < ActiveRecord::Base
  extend FriendlyId

  has_many :classified_listings
  attr_accessible :name, :slug, :heading_color

  friendly_id :name, use: [:slugged, :history]



end
