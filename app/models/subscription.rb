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

  before_destroy do
    if self.topic.user == self.user && !self.destroyed_by_association
      errors.add(:base, "Cannot delete as you are the admin")
      throw(:abort)
    end
  end
end
