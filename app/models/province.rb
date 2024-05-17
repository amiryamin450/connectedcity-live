class Province < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  has_many :regions
  has_many :municipalities
  belongs_to :country

  has_many :cities, foreign_key: "pruid"

  def self.ransackable_attributes(auth_object = nil)
    ["abbr", "country_code", "country_id", "country_name", "created_at", "id", "name", "province_code", "slug", "tax_gst", "tax_hst", "tax_pst", "updated_at"]
  end
end
