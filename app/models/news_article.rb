class NewsArticle < ApplicationRecord
  belongs_to :newsable, polymorphic: true
  belongs_to :location, -> { where(news_articles: { newsable_type: "Location" }) }, foreign_key: "newsable_id"
  belongs_to :user
  belongs_to :category

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  default_scope { order('created_at DESC') }

  validates :title, presence: true, length: { in: 1..100 }
  validates :content, presence: true, length: { in: 1..1500 }

  has_attached_file :image, styles: {
    thumb: "50x50#", list: "320x200#"
  },
    :url => "/system/news_articles/images/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/news_articles/images/:id/:style/:basename.:extension",
    default_url: "http://placehold.it/50x50"

  validates_attachment_size :image, less_than: 5.megabytes

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/, message: "Please upload a valid image. Accepted types include jpg, png."

  def geo_location
    if latitude.blank? || longitude.blank?
      { :lat => self.newsable.latitude, :long => self.newsable.longitude }
    else
      { :lat => latitude, :long => longitude }
    end
  end
end
