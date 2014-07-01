class Business < ActiveRecord::Base
  belongs_to :city
  belongs_to :country
  belongs_to :province

  has_many :locations
  has_and_belongs_to_many :users

  attr_accessible :address, :address_1, :alt_phone, :city_id, :contact_name, :country_id, :email, :fax, :name, :phone,
                  :postal_code, :province_id, :website, :user_ids, :users, :users_attributes, :user_tokens, :location_tokens

  attr_reader :user_tokens, :location_tokens
  

  def user_tokens=(ids)
    self.user_ids = ids.split(",")
  end

  def location_tokens=(ids)
    self.location_ids = ids.split(',')
  end

end