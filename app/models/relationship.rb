class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  include StreamRails::Activity
  as_activity

  after_create do
    StreamRails.feed_manager.follow_user(follower_id, followed_id)
  end

  after_destroy do
    StreamRails.feed_manager.unfollow_user(follower_id, followed_id)
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
