class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions

  scope :visible_to, -> (user) { user ? all : where(public: true) }
end
