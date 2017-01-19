class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if current_user.is_admin
      users_path
    elsif current_user.is_coach
      conversations_path
    elsif current_user.all_coaches_choosen? || current_user.expired?
      form_steps_path
    else
      conversations_path
    end
  end

  def create_conversations(user)
    begin_conversation(user, user.primary_coach)
    begin_conversation(user, user.secondary_coach)
    begin_conversation(user, user.tertiary_coach)
  end

  def begin_conversation(user, coach_id)
    coach = User.find(coach_id)
    @conversation = Conversation.new(user_id: user.id, coach_id: coach.id)
    @conversation.save!
    @message = Message.new(conversation_id: @conversation.id, user_id: coach.id, body: coach.greeting)
    @message.save!
  end

  def notify_coaches(user)
    TextCoachNewUserJob.perform_now(user, user.primary_coach) if user.primary_coach
    TextCoachNewUserJob.perform_now(user, user.secondary_coach) if user.secondary_coach
    TextCoachNewUserJob.perform_now(user, user.tertiary_coach) if user.tertiary_coach
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :phone_number, :is_admin, :is_coach, :primary_coach, :secondary_coach, :tertiary_coach, :greeting, :philosophy, :approved, :avatar, :secondary_users, :terms_read, :status, :expires_at])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :email, :is_admin, :is_coach, :primary_coach, :secondary_coach, :tertiary_coach, :greeting, :philosophy, :approved, :avatar, :terms_read, :status, :expires_at])
  end
end
