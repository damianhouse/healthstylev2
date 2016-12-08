require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Healthstylev2
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.paperclip_defaults = {
      :storage => :s3,
      :url =>':s3_domain_url',
      :s3_protocol => 'https',
      :path => '/:class/:attachment/:id_partition/:style/:filename',
      :s3_credentials => {
        :bucket => ENV['AWS_S3_BUCKET_V2'],
        :access_key_id => ENV['AWS_ACCESS_KEY_ID_V2'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY_V2']
      },
      s3_region: 'us-east-1',
    }
  end
end
