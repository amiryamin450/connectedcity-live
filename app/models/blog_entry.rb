class BlogEntry < ApplicationRecord
  belongs_to :bloggable, polymorphic: true
  belongs_to :location, foreign_key: "bloggable_id"
  belongs_to :user

  extend FriendlyId

  friendly_id :title, use: [:slugged, :history]

  default_scope { order('created_at DESC') }

  has_attached_file :image, styles: { thumb: "50x50#", :large => "320x>" },
                    :url => "/system/blog_entry/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/blog_entry/:id/:style/:basename.:extension"

  validates_attachment_size :image, less_than: 5.megabytes
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/, message: "Please upload a valid image. Accepted types include jpg, png."

  def self.ransackable_attributes(auth_object = nil)
    ["title", "content"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["location", "user"]
  end
end
