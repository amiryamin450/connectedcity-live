class Conversation < ActiveRecord::Base
  has_many :messages, dependent: :destroy
  belongs_to :sender, foreign_key: :sender_id, class_name: :Location
  belongs_to :recipient, foreign_key: :recipient_id, class_name: Location
 
  validates :sender_id, uniqueness: { scope: :recipient_id }
  attr_accessible :recipient_id, :sender_id
 
  def self.lookup(sender_id, recipient_id)
    conversation = (where(sender_id: sender_id, recipient_id: recipient_id).presence || where(sender_id: recipient_id, recipient_id: sender_id)).first
    return conversation if conversation.present?
 
    create(sender_id: sender_id, recipient_id: recipient_id)
  end
 
  def opposed_location(location)
    location == recipient ? sender : recipient
  end

  def recipient
    Location.unscoped.where(id: recipient_id).first
  end

  def sender
    Location.unscoped.where(id: sender_id).first
  end
end
