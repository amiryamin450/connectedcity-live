class CityNewsArticle < ActiveRecord::Base
  extend FriendlyId

  belongs_to :city_news_category 

  attr_accessible :city_news_category_id, :content, :title, :slug, :image

  friendly_id :title, use: [:slugged, :history]

  has_attached_file :image, styles: { thumb: "150x150", display: "640" },
                    url: "/system/city_news_articles/images/:id/:style/:basename.:extension",
                    path: ":rails_root/public/system/city_news_articles/images/:id/:style/:basename.:extension"

  validates_presence_of :title, :content, :city_news_category_id

end
