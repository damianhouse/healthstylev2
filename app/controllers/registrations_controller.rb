class RegistrationsController < Devise::RegistrationsController

  def create
    super
    @user
    if @user.persisted?
      UserMailer.welcome(@user).deliver
      # notify_admin(@user)
    end
  end

  private

  def notify_admin(user)
    user = User.find_by(id: session[:user_id])
    unless user.phone_number == ""
      begin
        client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
        message = client.messages.create from: '8284820730', to: ENV['ALEXS_PHONE_NUMBER'],

        body: "#{user.first_name + ' ' + user.last_name} just signed up for the app!"
      rescue
        flash[:notice] =  "Please enter a valid phone number."
      end
    end
  end
end
