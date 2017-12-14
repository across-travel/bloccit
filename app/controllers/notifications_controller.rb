class NotificationsController < ApplicationController
  before_action :require_sign_in

  def notifications
    @user = current_user
    enricher = StreamRails::Enrich.new
    feed = StreamRails.feed_manager.get_notification_feed(@user.id)
    results = feed.get()['results']
    @activities = enricher.enrich_activities(results)
  end
end
