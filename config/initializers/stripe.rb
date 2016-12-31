if Rails.env == 'production'
  Rails.configuration.stripe = {
    :publishable_key => ENV["LIVE_PUBLISHABLE_KEY"],
    :secret_key      => ENV["LIVE_SECRET_KEY"]
  }
else
  Rails.configuration.stripe = {
    :publishable_key => ENV["TEST_PUBLISHABLE_KEY"],
    :secret_key      => ENV["TEST_SECRET_KEY"]
  }
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]
