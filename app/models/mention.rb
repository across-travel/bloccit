class Mention < ApplicationRecord
  # has_many :mentionings
  belongs_to :mentionable, polymorphic: true

  # has_many :comments, through: :mentionings, source: :mentionable, source_type: :Comment
  # has_many :posts, through: :mentionings, source: :mentionable, source_type: :Post

  validates :username, presence: true

  validate :check_username

  def check_username
    errors.add(:base, 'User does not exist') unless User.find_by(username: self.username).present?
  end

  include StreamRails::Activity
  as_activity

  def activity_notify
    user = User.find_by(username: self.username)
    if user.present?
      [StreamRails.feed_manager.get_notification_feed(user.id)]
    end
  end

  def activity_object
    self.mentionable
  end

  def activity_actor
    self.mentionable.user
  end
end
