class SubscriptionsController < ApplicationController
  protect_from_forgery except: :webhook
  before_action :authenticate_user!, only: [:new, :create]
  respond_to :html, :json

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

  def webhook
    return nil if StripeWebhook.exists?(stripe_id: params[:id])

    StripeWebhook.create!(stripe_id: params[:id])
    event_json = Stripe::Event.retrieve(params[:id])
    event_object = event_json['data']['object']
    begin
      user = User.find_by(stripe_id: event_object['customer'])
      #refer event types here https://stripe.com/docs/api#event_types
      unless user.nil?
        case event_json['type']
        when 'invoice.payment_succeeded'
          handle_success_invoice(user, event_object)
        when 'invoice.payment_failed'
          handle_payment_failed(user, event_object)
        when 'charge.refunded'
          handle_charge_refunded(user, event_object)
        when 'customer.subscription.updated'
          handle_subscription_updated(user, event_object)
        end
      end
      render :json => {:status => 200}
    rescue Exception => ex
      render :json => {:status => 422, :error => "Webhook call failed"}
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

  def handle_success_invoice(user, event_object)
    plan = event.data.object.lines.data[0].plan.interval
    interval_count = event.data.object.lines.data[0].plan.interval_count
    user.add_time(plan, interval_count)
    UserMailer.receipt(user, event_object).deliver_now
  end

  def handle_payment_failed(user, event_object)
    UserMailer.payment_failed(user, event_object).deliver_now
  end

  def handle_subscription_updated(user, event_object)
    UserMailer.subscription_updated(user).deliver_now
  end

  def handle_charge_refunded(user, event_object)
    plan = event.data.object.lines.data[0].plan.interval
    interval_count = event.data.object.lines.data[0].plan.interval_count
    user.remove_time(plan, interval_count)
  end

  def normalize_code(code)
    code.gsub(/ +/, '').upcase
  end

  def apply_percentage_discount(amount)
    discount = amount * (self.discount_percent * 0.01)
    (amount - discount.to_i)
  end
  def apples
    p "testing things"
  end

  def apply_amount_discount(amount)
    amount - self.discount_amount
  end
end
