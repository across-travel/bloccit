class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  include StreamRails::Activity
  as_activity

  after_create do
    [StreamRails.feed_manager.get_feed("timeline", follower_id).follow("user", followed_id)]
  end

  before_destroy do
    feed = StreamRails.feed_manager.get_user_feed(self.follower.id)
    feed.remove_activity("Relationship:#{self.id}", foreign_id=true)
  end

  def activity_notify
    [StreamRails.feed_manager.get_notification_feed(self.followed_id)]
  end

  def activity_object
    self.followed
  end

  def activity_actor
    self.follower
  end

end
