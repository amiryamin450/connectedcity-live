class BlogEntry < ActiveRecord::Base
  belongs_to :bloggable, polymorphic: true
  belongs_to :user

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  default_scope order('created_at DESC')

  attr_accessible :content, :location_id, :title, :user_id, :slug, :image

  has_attached_file :image, styles: {
    thumb: "50x50#", list: "320x200#"
  },
    default_url: "http://placehold.it/50x50"

end
