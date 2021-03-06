class UserMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  def welcome(user)
    @user = user
    @user_name = "#{user.first_name} #{user.last_name}"
    attachments.inline['photo.jpg'] = File.read(Rails.root.join("app", "assets", "images", "HS_Logo_B3_LO.jpg")).to_s
    mail(to: @user.email, subject: 'Welcome to HealthStyle', from: "MyHealthStyle <HealthStyle@HealthStyle.com>")
  end

  def receipt(user, event)
    @user = user
    @user_name = "#{user.first_name} #{user.last_name}"
    @charge = number_to_currency(event.total)
    attachments.inline['photo.jpg'] = File.read(Rails.root.join("app", "assets", "images", "HS_Logo_B3_LO.jpg")).to_s
    mail(to: @user.email, subject: 'HealthStyle Receipt', from: "MyHealthStyle <HealthStyle@HealthStyle.com>")
  end

  def payment_failed(user, event)
    @user = user
    @user_name = "#{user.first_name} #{user.last_name}"
    @charge = number_to_currency(event.total)
    attachments.inline['photo.jpg'] = File.read(Rails.root.join("app", "assets", "images", "HS_Logo_B3_LO.jpg")).to_s
    mail(to: @user.email, subject: 'Healthstyle Payment', from: "MyHealthStyle <HealthStyle@HealthStyle.com>")
  end

  def subscription_updated(user)
    @user = user
    @user_name = "#{user.first_name} #{user.last_name}"
    attachments.inline['photo.jpg'] = File.read(Rails.root.join("app", "assets", "images", "HS_Logo_B3_LO.jpg")).to_s
    mail(to: @user.email, subject: 'HealthStyle Receipt', from: "MyHealthStyle <HealthStyle@HealthStyle.com>")
  end

  def subscription_deleted(user)
    @user = user
    @user_name = "#{user.first_name} #{user.last_name}"
    attachments.inline['photo.jpg'] = File.read(Rails.root.join("app", "assets", "images", "HS_Logo_B3_LO.jpg")).to_s
    mail(to: @user.email, subject: 'HealthStyle Receipt', from: "MyHealthStyle <HealthStyle@HealthStyle.com>")
  end
end
