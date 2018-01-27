class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  validates :user, presence: true
  validates :topic, presence: true

  after_create do
    self.user.like(self.topic)
    [StreamRails.feed_manager.get_feed("timeline", self.user.id).follow('topic', self.topic.id)]
  end

  after_destroy do
    self.user.unlike(self.topic)
    [StreamRails.feed_manager.get_feed("timeline", self.user.id).unfollow('topic', self.topic.id)]
  end

  before_destroy do
    if self.topic.user == self.user && !self.destroyed_by_association
      errors.add(:base, "Cannot delete as you are the admin")
      throw(:abort)
    else
      feed = StreamRails.feed_manager.get_user_feed(self.user.id)
      feed.remove_activity("Subscription:#{self.id}", foreign_id=true)
    end
  end

  include StreamRails::Activity
  as_activity

  def activity_notify
    if self.topic.user.admin?
      [StreamRails.feed_manager.get_notification_feed(self.topic.user.id)]
    end
  end

  def activity_object
    self.topic
  end

  def activity_actor
    self.user
  end
end
