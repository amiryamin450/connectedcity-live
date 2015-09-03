class SocialProfile < ActiveRecord::Base
  attr_accessible :access_token, :access_token_secret, :owner, :social_network, :uid

  belongs_to :owner, polymorphic: true

  def self.social_networks
    { facebook: 0, twitter: 1, instagram: 2 }
  end

  def social_network
    self.class.social_networks.key read_attribute(:social_network)
  end

  def social_network=(social_network)
    social_network = self.class.social_networks[social_network.to_sym] unless social_network.is_a? Integer
    super social_network
  end

  self.social_networks.each do |social_network|
    scope social_network[0], -> { where social_network: social_network[1] }

    define_method "#{social_network[0]}?" do
      read_attribute(:social_network) == social_network[1]
    end
  end
end
