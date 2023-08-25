class SessionsController < Devise::SessionsController
	layout 'application_v_2'

	def verify_two_factor
		if valid_user?
			if @user.phone_number && params[:otp].present?
				if params[:user_verified].present?
					flash[:sucess] = "You are logged in now"
					redirect_to new_user_session_path(params)
				else
					@res = VonageService.verify_2fa_otp(@user, params[:otp])
				end

				return
			end

			if @user.phone_number.nil? && params[:user][:phone_number].present?
				@user.phone_number = params[:user][:phone_number]
				@user.save!
			end

			VonageService.verify_2fa(@user) if @user.phone_number
		else
			flash[:danger] = "Invalid username or password"
			render js: "window.location.replace('#{new_user_session_path}')"
		end
	end

	private

	def valid_user?
		@user = User.find_by_email(params[:user][:email])
		@user&.valid_password?(params[:user][:password])
	end
end
