class EmploymentListing < ApplicationRecord

  belongs_to :location
  belongs_to :employment_category

  validates_presence_of :title, :application_deadline, :description, :number, :employment_category_id

  has_attached_file :cover_photo, :styles => { :thumb => "75x75#", :large => "320", :display => "640"},
                    :url => "/system/employment_listing/image/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/employment_listing/image/:id/:style/:basename.:extension"

  default_scope { where("application_deadline >= ?", Date.today) }
end
