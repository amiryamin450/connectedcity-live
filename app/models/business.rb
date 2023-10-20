class Business < ApplicationRecord
  belongs_to :city
  belongs_to :country
  belongs_to :province

  has_many :locations
  has_and_belongs_to_many :users

  attr_reader :user_tokens, :location_tokens

  def user_tokens=(ids)
    self.user_ids = ids.split(",")
  end

  def location_tokens=(ids)
    self.location_ids = ids.split(',')
  end
end
