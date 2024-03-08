class OrderMailer < ActionMailer::Base
  default from: 'donotreply@connectedcity.com'

  def order_created(recipient_email, order, user)
    @recipient_email = recipient_email
    @user = user
    @order = order
    mail(to: @recipient_email, subject: "e-Receipt – Order #{@order.display_number}")
  end
end
