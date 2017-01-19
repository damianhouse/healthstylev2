class TextWelcomeNewUserJob < ApplicationJob
  queue_as :default

  def perform(user)
    unless user.phone_number == ""
      begin
        client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
        message = client.messages.create from: '8284820730', to: user.phone_number,

        body: 'Welcome to MyHealthStyle! Your coaches are waiting for you! Please go to your dashboard and tell them all about you! Check back often for their responses, they may live in a different time zone'
      rescue
        TextAdminNewUserTextFailedJob.perform_now(user)
      end
    end
  end
end
