class OrderMailer < ActionMailer::Base
  default from: 'donotreply@connectedcity.com'

  def order_created(order, user)
    @user = user
    @order = order
    mail(to: @user.email, subject: 'e-Receipt – Order 12345689')
  end
end
