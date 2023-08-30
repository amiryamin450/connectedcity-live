class SessionsController < Devise::SessionsController
	layout 'application_v_2'
	before_filter :verify_2factor, only: :create

	def verify_two_factor
		@valid_user = valid_user?
		if @valid_user
			# Begin Vonage SMS 2FA Authentication
			# if @user.phone_number && params[:otp].present?
			# 	if params[:user_verified].present?
			# 		flash[:sucess] = "You are logged in now"
			# 		redirect_to new_user_session_path(params)
			# 	else
			# 		@res = VonageService.verify_2fa_otp(@user, params[:otp])
			# 	end

			# 	return
			# end

			# if @user.phone_number.nil? && params[:user][:phone_number].present?
			# 	@user.phone_number = params[:user][:phone_number]
			# 	@user.save!
			# end

			# VonageService.verify_2fa(@user) if @user.phone_number
			# END
		else
			flash[:danger] = "Invalid username or password"
			render js: "window.location.replace('#{new_user_session_path}')"
		end
	end

	private

	def valid_user?
		@user = User.find_by_email(params[:email] || params[:user][:email])
		@user&.valid_password?(params[:password] || params[:user][:password])
	end

	def verify_2factor
		if valid_user?
			if @user.google_authentic?(params[:otp])
				unless @user.required_otp_for_login
					@user.required_otp_for_login = true
					@user.save!
				end
				return
			else
				sign_out @user
				params = {}
				flash[:danger] = "Incorrect OTP"
				redirect_to new_user_session_path
			end
		else
			flash[:danger] = "Invalid username or password"
			redirect_to new_user_session_path
		end
	end
end
