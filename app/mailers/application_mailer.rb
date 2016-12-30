class ApplicationMailer < ActionMailer::Base
  default from: "MyHealthStyle <HealthStyle@HealthStyle.com>"
  layout 'mailer'

  def number_to_currency(number)
    '$' + (number/100).to_s + '.00'
  end
end
