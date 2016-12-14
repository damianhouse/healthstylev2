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
    if @user.save
      notify_user(@user)
      notify_admin(@user)
      UserMailer.welcome(@user).deliver_now
    end
  end

  protected

  def notify_user(user)
    unless user.phone_number == ""
      begin
        client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
        message = client.messages.create from: '8284820730', to: user.phone_number,

        body: 'Welcome to MyHealthStyle! We are so excited and will contact you as soon as your coaching team is assigned to you!'
      rescue
        flash[:notice] =  "Please enter a valid phone number."
      end
    else
      redirect_to charges_new_path
    end
  end

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource) unless current_user
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
