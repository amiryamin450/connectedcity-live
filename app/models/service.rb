class Service < ApplicationRecord
  belongs_to :location

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  validates_presence_of :description, :name
  has_attached_file :image, styles: {
    thumb: "150x150#", list: "320x200#"
  }

  after_save do |service|
    Sunspot.index! service.location if service.location
  end
end
