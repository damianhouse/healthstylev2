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
      notify_admin(@user)
      notify_coaches(@user)
      UserMailer.welcome(@user).deliver_now
    end
  end

  protected

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource) unless current_user
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
