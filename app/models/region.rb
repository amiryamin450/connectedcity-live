# TODO: remove, no longer used
class Region < ApplicationRecord

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  belongs_to :province
  has_many :municipalities

  def access_link
    "/#{province.slug}/#{slug}"
  end
end
