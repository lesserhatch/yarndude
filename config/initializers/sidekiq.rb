if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://redis.private.yarndude.com:6379/0' }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://redis.private.yarndude.com:6379/0' }
  end
end