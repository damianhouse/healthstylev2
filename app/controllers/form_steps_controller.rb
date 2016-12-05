class FormStepsController < ApplicationController
  include Wicked::Wizard
  before_action :authenticate_user!
  steps :choose_coaches

  def show
    @user = User.find_by(id: current_user.id)
    @coaches = User.where("is_coach = ? AND approved = ?", true, true)
    render_wizard
  end

  def update
    @user = current_user
    @coaches = User.where("is_coach = ? AND approved = ?", true, true)
    @user.update_attributes(user_params)
    render_wizard @user
    if @user.persisted?
      # create_conversations(@user)
      # UserMailer.welcome(@user).deliver
      # notify_admin(@user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:primary_coach, :secondary_coach, :tertiary_coach, :status)
  end
end
