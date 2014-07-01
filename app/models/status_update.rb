class StatusUpdate < ActiveRecord::Base
  belongs_to :statusable, polymorphic: true

  default_scope order('created_at DESC')

  attr_accessible :content, :provider
  validates_presence_of :content

end
