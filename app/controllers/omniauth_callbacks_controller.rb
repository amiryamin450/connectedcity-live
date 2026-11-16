class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # While sign-ups are closed, Facebook can only sign in existing accounts.
  def all
    auth = request.env["omniauth.auth"]
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    if user
      flash.notice = "Signed in!"
      sign_in_and_redirect user
    else
      redirect_to new_user_session_path, alert: 'New sign-ups are closed for now.'
    end
  end

  alias_method :facebook, :all

end