class EmploymentCategory < ActiveRecord::Base
  extend FriendlyId
  has_many :employment_listings
  
  attr_accessible :heading_color, :name, :slug

  friendly_id :name, use: [:slugged, :history]

end
