class NotificationsController < ApplicationController
  before_action :require_sign_in
  before_action :create_enricher

  def notifications
    feed = StreamRails.feed_manager.get_notification_feed(current_user.id)
    results = feed.get(mark_seen: true, mark_read: true, limit: 5)['results']
    @activities = @enricher.enrich_aggregated_activities(results)
  end

  def create_enricher
    @enricher = StreamRails::Enrich.new
  end
end
