class RegistrationsController < Devise::RegistrationsController

  def new
    super
  end

  def create
    super
    # @user.secondary_coaches = params["user"]["secondary_coaches"].reject!(&:empty?)*","
    @user.secondary_coaches = params["user"]["secondary_coaches"].reject!(&:empty?).map {|n| n.to_i}
    @user.save
    if @user.persisted?
      create_conversations(@user)
      # UserMailer.welcome(@user).deliver
      # notify_admin(@user)
    end
  end

  private
  def create_conversations(user)
    @coaches = user.secondary_coaches.map {|coach| User.find(coach)}
    @coaches << User.find(user.primary_coach)
    @coaches.each do |coach|
      @conversation = Conversation.new(user_id: user.id, coach_id: coach.id)
      @conversation.save!
      @message = Message.new(conversation_id: @conversation.id, user_id: coach.id, body: coach.greeting)
      @message.save!
    end
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
