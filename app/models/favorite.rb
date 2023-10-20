class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :location
  has_many :location_status_updates, -> { distinct }, through: :location, source: :status_updates
end
