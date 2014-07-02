class Redemption < ActiveRecord::Base
  belongs_to :coupon, counter_cache: true
  belongs_to :user 

  validates_presence_of :coupon_id, :user_id

  attr_accessible :coupon_id, :transaction_id, :user_id, :redeemed
end
