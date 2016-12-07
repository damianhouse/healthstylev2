class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if current_user.is_admin
      users_path
    elsif current_user.is_coach
      conversations_path
    elsif current_user.all_coaches_choosen?
      form_steps_path
    elsif current_user.expired?
      subscriptions_new_path
    else
      form_steps_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :phone_number, :is_admin, :is_coach, :primary_coach, :secondary_coach, :tertiary_coach, :greeting, :philosophy, :approved, :avatar, :secondary_users, :terms_read, :status, :expires_at])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :email, :is_admin, :is_coach, :primary_coach, :secondary_coach, :tertiary_coach, :greeting, :philosophy, :approved, :avatar, :terms_read, :status, :expires_at])
  end
end
