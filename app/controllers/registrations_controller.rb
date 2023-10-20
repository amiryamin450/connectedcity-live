class RegistrationsController < Devise::RegistrationsController
	layout 'application_v_2'

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
end
