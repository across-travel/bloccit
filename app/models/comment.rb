class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :body, length: { minimum: 5 }, presence: true
  validates :user, presence: true

  scope :visible_to, -> (user) { user ? all : joins(:topic).where('posts.topics.public' => true) }

  default_scope { order('updated_at DESC') }
end
