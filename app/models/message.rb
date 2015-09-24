class Message
  include ActiveModel::Validations
  include ActiveModel::Conversion

  extend ActiveModel::Naming

  attr_accessor :recipients, :subject, :body, :conversation_id, :attachment

  validates :recipients, presence: true, unless: :conversation_id
  validates :subject, presence: true, unless: :conversation_id
  validates :body, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send "#{name}=", value
    end
  end

  def persisted?
    false
  end
end
