class ConfirmationsController < Devise::ConfirmationsController
	layout 'application_v_2'

	def show
		self.resource = resource_class.confirm_by_token(params[:confirmation_token])
		yield resource if block_given?

		if resource.errors.empty?
			flash[:notice] = "Your account was successfully confirmed. Please sign in now"
			redirect_to after_confirmation_path_for(resource_name, resource)
		else
			flash[:danger] = resource.errors.full_messages.first
			respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
		end
	end

  protected

	def after_confirmation_path_for(resource_name, resource)
		new_user_session_path
	end
end
