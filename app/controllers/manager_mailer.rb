class ManagerMailer < ActionMailer::Base
  default from: 'donotreply@connectedcity.com'

  def new_manager_email(location, user)
    @user = user
    @location = location
    mail(to: user.email, subject: "ConnectedCity Manager for #{@location.name}")
  end
end
