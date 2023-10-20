class EmploymentCategory < ApplicationRecord
  extend FriendlyId
  has_many :employment_listings

  friendly_id :name, use: [:slugged, :history]
end
