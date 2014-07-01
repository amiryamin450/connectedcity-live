class Brand < ActiveRecord::Base
  belongs_to :business
  has_and_belongs_to_many :locations


  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  attr_accessible :description, :name, :slug, :logo
  has_attached_file :logo, :styles => { thumb: "50x50" },
    :url => "/assets/brand_logo/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/brand_logo/:id/:style/:basename.:extension",
    :default_url => "http://placehold.it/115x75"


end
