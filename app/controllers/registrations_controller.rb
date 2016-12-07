class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  prepend_before_action :require_no_authentication, only: [:cancel ]


  def new
    super
    @user = User.new
    @coaches = User.where("is_coach = ? AND approved = ?", true, true)
  end

  def create
    super
    if current_user.is_admin
      create_conversations(@user) if @user.all_coaches_choosen?
      if Rails.env == 'production'
        UserMailer.welcome(@user).deliver
      end
    end
  end

  protected

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

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource) unless current_user
  end

  def update_resource(resource, params)
    resource.update_without_password(params) if current_user.is_admin
  end
end
