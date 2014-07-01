class Country < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  
  default_scope where(country_code: 'CA')

  has_many :provinces
  has_many :locations


  attr_accessible :country_code, :name
  validates_presence_of :country_code, :name
end
