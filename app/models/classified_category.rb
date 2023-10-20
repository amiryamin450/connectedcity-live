class ClassifiedCategory < ApplicationRecord
  extend FriendlyId

  has_many :classified_listings

  friendly_id :name, use: [:slugged, :history]
end
