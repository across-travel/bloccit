class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :post
  after_save :update_post

  scope :visible_to, -> (user) { user ? all : joins(:topic).where('posts.topics.public' => true) }

  validates :value, inclusion: { in: [-1, 1], message: "%{value} is not a valid vote." }, presence: true

  private

  def update_post
    post.update_rank
  end
end
