class FormStepsController < ApplicationController
  include Wicked::Wizard
  before_action :authenticate_user!
  before_action :coaches_choosen?
  steps :choose_coaches

  def show
    @user = User.find_by(id: current_user.id)
    @coaches = User.where("is_coach = ? AND approved = ?", true, true)
    render_wizard
  end

  def update
    @user = current_user
    @coaches = User.where("is_coach = ? AND approved = ?", true, true)
    @user.update_attributes(user_params)
    render_wizard @user
    if @user.persisted?
      create_conversations(@user)
      if Rails.env == 'production'
        UserMailer.welcome(@user).deliver
        notify_admin(@user)
      end
    end
  end

  private

  def coaches_choosen?
    render_wizard unless current_user.all_coaches_choosen?
  end

  def finish_wizard_path
    subscriptions_new_path
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

  def notify_admin(user)
    begin
      client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
      message = client.messages.create from: '8284820730', to: ENV['ALEXS_PHONE_NUMBER'],

      body: "#{user.first_name + ' ' + user.last_name} just signed up for the app!"
    rescue
      flash[:notice] =  "Please enter a valid phone number."
    end
  end
  def user_params
    params.require(:user).permit(:primary_coach, :secondary_coach, :tertiary_coach, :status)
  end
end
