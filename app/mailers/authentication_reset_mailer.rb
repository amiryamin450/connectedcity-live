class AuthenticationResetMailer < ActionMailer::Base
  default from: 'donotreply@connectedcity.com'

  def two_factor_qr(user)
    @user = user
    mail(to: @user.email, subject: 'Confirm reset authentication QR')
  end
end
