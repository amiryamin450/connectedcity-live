class NewsArticle < ActiveRecord::Base
  belongs_to :newsable, polymorphic: true
  belongs_to :location, foreign_key: "newsable_id", conditions: { news_articles: { newsable_type: "Location" } }
  belongs_to :user
  belongs_to :category

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  default_scope order('created_at DESC')

  attr_accessible :content, :location_id, :title, :user_id, :slug, :user, :image, :category_id

  has_attached_file :image, styles: {
    thumb: "50x50#", list: "320x200#"
  },
    :url => "/system/news_articles/images/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/news_articles/images/:id/:style/:basename.:extension",
    default_url: "http://placehold.it/50x50"
end
