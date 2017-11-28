class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :post
  after_save :update_post

  validates :value, inclusion: { in: [-1, 1], message: "%{value} is not a valid vote." }, presence: true

  after_create do
    self.user.like(self.post)
  end

  after_update do
    self.value == -1 ? self.user.unlike(self.post) : self.user.like(self.post)
  end

  private

  def update_post
    post.update_rank
  end
end
