class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  validates :user, presence: true
  validates :topic, presence: true

  after_create do
    self.user.like(self.topic)
  end

  after_destroy do
    self.user.unlike(self.topic)
  end

  include StreamRails::Activity
  as_activity

  def activity_notify
    if self.topic.user.admin?
      [StreamRails.feed_manager.get_notification_feed(self.topic.user.id)]
    end
  end

  def activity_object
    self.topic.user
  end

  def activity_actor
    self.user
  end
end
