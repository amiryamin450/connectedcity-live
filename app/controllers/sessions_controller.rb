class SessionsController < Devise::SessionsController
	layout 'application_v_2'
	before_action :verify_2factor, only: :create

	def verify_two_factor
		@valid_user = valid_user?
		if @valid_user

		else
			flash[:danger] = "Invalid username or password"
			render js: "window.location.replace('#{new_user_session_path}')"
		end
	end

	def request_reset_2fa_code
		if valid_user?
			@user.reset_code = SecureRandom.hex
			@user.save!
			AuthenticationResetMailer.two_factor_qr(@user).deliver
			flash[:notice] = 'Reset email was sent. Please check your email for reset instructions.'
		else
			flash[:notice] = 'Invalid email or password'
		end

		render js: "window.location.replace('#{new_user_session_path}')"
	end

	def reset_2fa_code
		@user = User.where(reset_code: params[:id]).first
		@user.required_otp_for_login = false
		@user.reset_code = nil
		@user.save!

		flash[:notice] = 'Password was reset. Please proceed to login again'
		redirect_to new_user_session_path
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
