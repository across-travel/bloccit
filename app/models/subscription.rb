class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  validates :user, presence: true
  validates :topic, presence: true
end
