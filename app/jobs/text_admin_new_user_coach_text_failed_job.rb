class TextAdminNewUserCoachTextFailedJob < ApplicationJob
  queue_as :default

  def perform(user, the_coach)
    begin
      coach = User.find(the_coach)
      client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
      message = client.messages.create from: '8284820730', to: ENV['ALEXS_PHONE_NUMBER'],

      body: "#{user.first_name + ' ' + user.last_name} just signed up for the app and their reminder text for Coach #{coach.first_name} failed."
    end
  end
end
