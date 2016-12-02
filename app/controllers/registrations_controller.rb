class RegistrationsController < Devise::RegistrationsController

  def new
    super
  end

  def create
    super
    if @user.persisted?
      create_conversations(@user)
      # UserMailer.welcome(@user).deliver
      # notify_admin(@user)
    end
  end

  private

  def create_conversations(user)
    begin_conversation(user, user.primary_coach)
    begin_conversation(user, user.secondary_coach)
    begin_conversation(user, user.tertiary_coach)
  end

  def begin_conversation(user, coach)
    @conversation = Conversation.new(user_id: user, coach_id: coach)
    @conversation.save!
    @message = Message.new(conversation_id: @conversation, user_id: coach, body: coach.greeting)
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
end
