class RegistrationsController < Devise::RegistrationsController

  def create
    super
    @user
    if @user.persisted?
      UserMailer.welcome(@user).deliver
    end
  end
end
