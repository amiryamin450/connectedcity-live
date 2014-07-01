class Province < ActiveRecord::Base

  default_scope where(country_code: 'CA')

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  belongs_to :country

  has_many :cities
  has_and_belongs_to_many :regions
  has_many :locations


  attr_accessible :abbr, :country_id, :name, :country_code, :country, :province_code, :country_name
  validates_presence_of :abbr, :country_id, :name

end
