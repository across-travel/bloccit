Sidekiq.configure_client do |config|
  if Rails.env.production?
    config.redis = { size: 3, url: ENV["REDIS_URL"] }
  end
end

Sidekiq.configure_server do |config|
  if Rails.env.production?
    config.redis = { size: 2 }
  end
end
