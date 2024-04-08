class RegistrationsController < Devise::RegistrationsController
	layout 'application_v_2'
	before_action :configure_permitted_parameters, only: [:create]

	def edit
		@profile = current_user.profile
		super
	end

  def after_sign_up_path_for(resource)
  	if request.referrer.include?('business_sign_up')
  	  '/businessthankyou'
  	else
  	  '/thankyou'
  	end
  end

  def after_inactive_sign_up_path_for(resource)
  	if request.referrer.include?('business_sign_up')
  	  '/businessthankyou'
  	else
  	  '/thankyou'
  	end
  end

	protected

	def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
			:first_name, :last_name, :phone_number, :address
		])
  end
end
