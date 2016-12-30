StripeEvent.event_retriever = lambda do |params|
 return nil if StripeWebhook.exists?(stripe_id: params[:id])

 StripeWebhook.create!(stripe_id: params[:id])
 Stripe::Event.retrieve(params[:id])
end

StripeEvent.configure do |events|
  events.subscribe 'invoice.payment_succeeded' do |event|
    user = User.find_by_stripe_id(event.data.object.customer)
    plan = event.data.object.lines.data[0].plan.interval
    interval_count = event.data.object.lines.data[0].plan.interval_count
    user.add_time(plan, interval_count)
    UserMailer.receipt(user, event).deliver_now
  end
  events.subscribe 'invoice.payment_failed' do |event|
    user = User.find_by_stripe_id(event.data.object.customer)
    UserMailer.payment_failed(user, event).deliver_now
  end
  events.subscribe 'charge.refunded' do |event|
    user = User.find_by_stripe_id(event.data.object.customer)
    plan = event.data.object.lines.data[0].plan.interval
    interval_count = event.data.object.lines.data[0].plan.interval_count
    user.remove_time(plan, interval_count)
  end
  events.subscribe 'subscription.updated' do |event|
    user = User.find_by_stripe_id(event.data.object.customer)
    UserMailer.subscription_updated(user).deliver_now
  end
end
