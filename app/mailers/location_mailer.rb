class LocationMailer < ActionMailer::Base
  default from: 'donotreply@connectedcity.com'

  def pending_claim_email(location, user)
    @user = user
    @location = location
    mail(to: 'admin@connectedcity.com', subject: 'Location Claimed!')
  end

  def claim_rejected_email(location, user)
    @location = location
    @user = user
    mail(to: @user.email, subject: 'ConnectedCity Location Claim Denied')
  end

  def claim_approved_email(location, user)
    @location = location
    @user = user
    mail(to: @user.email, subject: 'ConnectedCity Location Claim Approved')
  end
end