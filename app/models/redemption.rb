class Redemption < ApplicationRecord
  belongs_to :coupon, counter_cache: true
  belongs_to :user 

  validates_presence_of :coupon_id, :user_id
end
