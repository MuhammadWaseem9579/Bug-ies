class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?
	helper_method :manager?
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:user_type])
	    # devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :user_type ,:password, :password_confirmation) }
	    # devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
	    # devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation,:reset_password_token) }
	end

	def manager?
			!!user_signed_in? && current_user.user_type == "manager"
	end

end
