class RegistrationsController < Devise::RegistrationsController

  def new
    super
    session[:user_params] ||= {}
    @user = User.new(session[:user_params])
    @current_step = "first_step"
    @coaches = User.where("is_coach = ? AND approved = ?", true, true)
  end

  def create
    super
    session[:user_params].deep_merge!(params[:user]) if params[:user]
    @user = User.new(session[:user_params])
    @user.status = session[:user_step]
    @coaches = User.where("is_coach = ? AND approved = ?", true, true)
    if @user.valid?
      if params[:previous_button]
        @user.previous_step
      elsif @user.last_step?
        @user.save if @user.all_coaches_choosen?
        session[:user_step] = nil
        session[:user_params] = nil
        create_conversations(@user)
        UserMailer.welcome(@user).deliver
        notify_admin(@user)
        redirect_to subscriptions_new_path
      else
        @user.next_step
      end
      session[:user_step] = @user.status
    end
  end

  private

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
end
