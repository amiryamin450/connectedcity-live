class CityNewsArticle < ActiveRecord::Base
  extend FriendlyId

  belongs_to :city_news_category
  belongs_to :city
  belongs_to :district
  belongs_to :neighborhood

  attr_accessible :city_news_category_id, :city_id, :district_id, :neighborhood_id, :content, :title, :slug, :image

  friendly_id :title, use: [:slugged, :history]

  has_attached_file :image, styles: { thumb: "150x150", display: "640" },
                    url: "/system/city_news_articles/images/:id/:style/:basename.:extension",
                    path: ":rails_root/public/system/city_news_articles/images/:id/:style/:basename.:extension"

  validates_presence_of :title, :content, :city_news_category_id

end
