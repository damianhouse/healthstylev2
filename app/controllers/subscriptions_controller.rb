class SubscriptionsController < ApplicationController
  protect_from_forgery except: :webhook
  before_action :authenticate_user!, only: [:new, :create]

  def new
    plans_data = Stripe::Plan.all
    @plans = plans_data[:data]
  end

  def create
  end

  def webhook
  end
end
