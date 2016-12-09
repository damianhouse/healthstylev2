class FormStepsController < ApplicationController
  include Wicked::Wizard
  before_action :authenticate_user!
  before_action :coaches_choosen?
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
      create_conversations(@user)
      if Rails.env == 'production'
        UserMailer.welcome(@user).deliver
        notify_admin(@user)
      end
    end
  end

  private

  def is_user?
    true unless current_user.is_admin || current_user.is_coach
  end

  def coaches_choosen?
    render_wizard unless current_user.all_coaches_choosen?
  end

  def finish_wizard_path
    subscriptions_new_path
  end

  def user_params
    params.require(:user).permit(:primary_coach, :secondary_coach, :tertiary_coach, :status)
  end
end
