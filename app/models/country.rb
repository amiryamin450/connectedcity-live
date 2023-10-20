class Country < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  
  default_scope { where(country_code: 'CA') }

  has_many :provinces
  has_many :locations

  validates_presence_of :country_code, :name
end
