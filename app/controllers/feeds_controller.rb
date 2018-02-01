class FeedsController < ApplicationController
  before_action :authenticate_user!
  before_action :create_enricher

  def notifications
    feed = StreamRails.feed_manager.get_notification_feed(current_user.id)
    results = feed.get(mark_seen: true, mark_read: true, limit: 5)['results']
    @activities = @enricher.enrich_aggregated_activities(results)
  end

  def news_feed
    feed = StreamRails.feed_manager.get_news_feeds(current_user.id)[:flat]
    results = feed.get['results']
    @activities = @enricher.enrich_activities(results)
  end

  def create_enricher
    @enricher = StreamRails::Enrich.new
  end
end
