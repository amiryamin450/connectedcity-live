class VideoCall < ActiveRecord::Base
  attr_accessible :user_business_id, :user_call_id, :session_id, :status, :token, :location_id
end
