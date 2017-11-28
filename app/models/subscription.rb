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
end
