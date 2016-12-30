class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    plans_data = Stripe::Plan.all
    @plans = plans_data[:data]
  end

  def create
    @user = current_user
    @code = normalize_code(params[:couponCode])
    @amount = params[:amount].to_f
    @plan = params[:plan]
    plan_interval = params[:plan_interval]
    interval_count = params[:interval_count].to_i

    if @code.present?
      is_valid?(@code, plan_interval, interval_count)
      if @coupon == nil
        redirect_to subscriptions_new_path
        return
      end
    else
      @code = nil
      charge_metadata = {
        :plan_interval => plan_interval,
        :interval_count => interval_count
      }
    end

    begin
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken],
        :plan => @plan,
        :coupon => @code,
        :metadata => charge_metadata
      )
      @final_amount = @amount.to_f if @final_amount.nil?
      @current_user.add_time(plan_interval, interval_count)
      @current_user.stripe_id = customer.id
      @current_user.save!
      flash[:notice] = "Your subscription was successfully created."
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to subscriptions_new_path
    end
  end

  private

  def is_valid?(coupon, plan_interval, interval_count)
    begin
      @coupon = Stripe::Coupon.retrieve(coupon)
      @discount_percent = @coupon.percent_off
      @amount_off = @coupon.amount_off
      if @discount_percent
        @final_amount = (@amount * (1 - @discount_percent))
        @discount_amount = (@amount - @final_amount)
        discount_percent_human = @discount_percent.to_s + '%'
        charge_metadata = {
          :coupon_code => coupon,
          :coupon_discount => discount_percent_human,
          :plan_interval => plan_interval,
          :interval_count => interval_count
        }
      elsif @amount_off
        @final_amount = @amount - @amount_off
        @discount_amount = (@amount - @final_amount)
        charge_metadata = {
          :coupon_code => coupon,
          :coupon_discount => @discount_amount,
          :plan_interval => plan_interval,
          :interval_count => interval_count
        }
      end
    rescue Stripe::InvalidRequestError => e
      flash[:notice] = 'Card not processed because coupon code is not valid or has expired.'
    end
  end

  def normalize_code(code)
    code.gsub(/ +/, '').upcase
  end

  def apply_percentage_discount(amount)
    discount = amount * (self.discount_percent * 0.01)
    (amount - discount.to_i)
  end

  def apply_amount_discount(amount)
    amount - self.discount_amount
  end
end
