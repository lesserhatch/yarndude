require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Temperatureblanket
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.site_name = 'Yarndude'
    config.active_job.queue_adapter = :sidekiq
    config.action_mailer.delivery_method = :aws_sdk
    config.action_mailer.default_url_options = {
      host: 'yarndude.com',
      protocol: 'https'
    }
    config.free_mode = true
  end
end
