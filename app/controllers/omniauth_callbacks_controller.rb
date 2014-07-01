class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    user = User.from_facebook(request.env["omniauth.auth"])
    if user.persisted?
      flash.notice = "Signed in!"
      sign_in_and_redirect user
    else
      user.skip_confirmation!
      session['devise.user_attributes'] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  alias_method :facebook, :all

end