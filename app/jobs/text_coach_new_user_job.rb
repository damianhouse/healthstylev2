class TextCoachNewUserJob < ApplicationJob
  queue_as :default

  def perform(user, the_coach)
    coach = User.find(the_coach)
    unless coach.phone_number == ""
      byebug
      begin
        client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
        message = client.messages.create from: '8284820730', to: coach.phone_number,

        body: "#{user.first_name} added you as a coach! www.myhealthstyleapp.com/conversations.com"
      rescue
        TextAdminNewUserCoachTextFailedJob.perform_now(user, the_coach)
      end
    end
  end
end
