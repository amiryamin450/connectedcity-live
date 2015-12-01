class CarouselImage < ActiveRecord::Base

  attr_accessible :caption, :title, :image
  belongs_to :carouselable, polymorphic: true

  validates_presence_of :title
  validates_attachment :image, :presence => true

  has_attached_file :image, :styles => { thumb: "150", default: "1960x714#" },
    url: "/system/carousel/image/:id/:style/:basename.:extension",
    path: ":rails_root/public/system/carousel/image/:id/:style/:basename.:extension",
    default_url: "/system/carousel/image/missing.png"

end
