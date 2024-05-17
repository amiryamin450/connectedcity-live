class Country < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  
  default_scope { where(country_code: 'CA') }

  has_many :provinces
  has_many :locations

  validates_presence_of :country_code, :name

  def self.ransackable_attributes(auth_object = nil)
    ["country_code", "created_at", "id", "name", "slug", "updated_at"]
  end
end
