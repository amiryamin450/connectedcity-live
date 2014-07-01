class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  attr_accessible :category, :location_id, :user_id
end
