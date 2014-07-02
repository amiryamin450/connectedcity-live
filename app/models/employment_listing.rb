class EmploymentListing < ActiveRecord::Base

  belongs_to :location
  belongs_to :employment_category 

  attr_accessible :advantages, :application_deadline, :description, :locations, :number, 
                  :number_of_positions, :qualifications, :title, :location_id, :employment_category_id,
                  :cover_photo

  validates_presence_of :title, :application_deadline, :description, :number, :employment_category_id

  has_attached_file :cover_photo, :styles => { :thumb => "75x75#", :large => "320", :display => "640"},
                    :url => "/system/employment_listing/image/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/employment_listing/image/:id/:style/:basename.:extension"

end
