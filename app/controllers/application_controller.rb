class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if current_user.is_admin
      users_path
    else
      conversations_path
    end
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :phone_number, :is_admin, :is_coach, :primary_coach, :secondary_coaches, :greeting, :philosophy, :approved, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :email, :is_admin, :is_coach, :primary_coach, :secondary_coaches, :greeting, :philosophy, :approved, :avatar ])
  end
end
