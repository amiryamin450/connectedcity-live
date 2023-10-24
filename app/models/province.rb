class Province < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  has_many :regions
  has_many :municipalities
  belongs_to :country

  has_many :cities, foreign_key: "pruid"
end
