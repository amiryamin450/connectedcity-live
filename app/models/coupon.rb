class Coupon < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_many :redemptions
  belongs_to :location

  has_attached_file :image, :styles => { :thumb => "75x75#", :large => "320", :display => "640", :list => "200x100" },
                    :url => "/system/coupon/images/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/coupon/images/:id/:style/:basename.:extension",
                    :default_url => "http://placehold.it/200x100"

  validates :name, presence: true
  validates :description, presence: true
  validates :expiration, presence: true
  validates :howmany, presence: true,  numericality: { only_integer: true, greater_than: 0 }

  default_scope { where("expiration >= ?", Date.today) }

  def current_coupon_code
    "#{code_prefix}-#{location.id}-#{how_many_left}"
  end

  def how_many_left
    howmany - redemptions_count
  end

  def qr_code(user_id)
    url = redeem_coupon_url(redemptions.where(user_id: user_id).first.id)
    "https://chart.googleapis.com/chart?cht=qr&chs=#{150}x#{150}&chl=#{CGI.escape(url)}&chld=H|1"
  end

  def times_redeemed
    redemptions.where(redeemed: true).size
  end

end
