class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  has_many :location_status_updates, through: :location, source: :status_updates, uniq: true

  attr_accessible :category, :location_id, :user_id, :location
end
