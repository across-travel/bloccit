require 'stream_rails'

StreamRails.configure do |config|
  config.api_key     = "dhvnb7q4unhy"
  config.api_secret  = "nuagnaukj7w9d476x6yv3qv6q82p2gg8kd5hfygb7xbc6jxgagpsjwt554rr4vph"
  config.timeout     = 30                # Optional, defaults to 3
  config.location    = 'eu-west'         # Optional, defaults to 'us-east'
  # If you use custom feed names, e.g.: timeline_flat, timeline_aggregated,
  # use this, otherwise omit:
  config.news_feeds = { flat: "timeline" }
  # Point to the notifications feed group providing the name, omit if you don't
  # have a notifications feed
  config.notification_feed = "notification"
end
