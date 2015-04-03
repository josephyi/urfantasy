Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis' }
  config.server_middleware do |chain|
    chain.add Sidekiq::Throttler, storage: :redis
  end
end