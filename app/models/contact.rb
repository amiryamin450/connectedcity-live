class Contact < MailForm::Base
  attribute :name, :validate => true
  attribute :email, :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "ConnectedCity Customer Contact",
      :to => "info@connectedcity.com",
      # needs to be from an email address associated with the Amazon SES account otherwise we can't send
      :from => "donotreply@connectedcity.com"
    }
  end
end