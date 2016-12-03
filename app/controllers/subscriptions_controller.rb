class SubscriptionsController < ApplicationController
  protect_from_forgery except: :webhook
  before_action :authenticate_user!, only: [:new, :create]

  def new
    plans_data = Stripe::Plan.all
    @plans = plans_data[:data]
  end

  def create
    @user = current_user
    code = params[:couponCode]
    @amount = params[:amount].to_f
    @plan = params[:plan]
    plan_interval = params[:plan_interval]
    interval_count = params[:interval_count].to_i

    if !code.blank?
      @coupon = Stripe::Coupon.retrieve(normalize_code(code))
      if @coupon && @coupon.valid
        @coupon.code = code
        @discount_percent = @coupon.percent_off
        @amount_off = @coupon.amount_off

        if @discount_percent
          @final_amount = (@amount * (1 - @discount_percent))
          @discount_amount = (@amount - @final_amount)
          discount_percent_human = @discount_percent.to_s + '%'
          charge_metadata = {
            :coupon_code => code,
            :coupon_discount => discount_percent_human,
            :plan_interval => plan_interval,
            :interval_count => interval_count
          }
          customer = Stripe::Customer.create(
            :email => params[:stripeEmail],
            :source  => params[:stripeToken],
            :plan => @plan,
            :coupon => code,
            :metadata => charge_metadata
          )
        elsif @amount_off
          @final_amount = @amount - @amount_off
          @discount_amount = (@amount - @final_amount)
          charge_metadata = {
            :coupon_code => code,
            :plan_interval => plan_interval,
            :interval_count => interval_count
          }
          customer = Stripe::Customer.create(
            :email => params[:stripeEmail],
            :source  => params[:stripeToken],
            :plan => @plan,
            :coupon => code,
            :metadata => charge_metadata
          )
        end
      else
        flash[:error] = 'Coupon code is not valid or has expired.'
        redirect_to subscriptions_new_path
        return
      end

    else
      @final_amount = @amount.to_i
      charge_metadata = {
        :coupon_code => nil,
        :coupon_discount => nil,
        :plan_interval => plan_interval,
        :interval_count => interval_count
      }
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken],
        :plan => @plan,
        :coupon => nil,
        :metadata => charge_metadata
      )
    end

    @current_user.add_time(plan_interval, interval_count)
    @current_user.stripe_id = customer.id
    @current_user.save!
    flash[:notice] = "Your subscription was successfully created."
    
    rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to subscriptions_new_path
  end

  def webhook
    begin
      event_json = JSON.parse(request.body.read)
      event_object = event_json['data']['object']
      #refer event types here https://stripe.com/docs/api#event_types
      case event_json['type']
        when 'invoice.payment_succeeded'
          handle_success_invoice event_object
        when 'invoice.payment_failed'
          handle_failure_invoice event_object
        when 'charge.failed'
          handle_failure_charge event_object
        when 'customer.subscription.deleted'
        when 'customer.subscription.updated'
      end
    rescue Exception => ex
      render :json => {:status => 422, :error => "Webhook call failed"}
      return
    end
    render :json => {:status => 200}
  end

  private

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
