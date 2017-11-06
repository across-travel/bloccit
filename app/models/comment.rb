class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings

  validates :body, length: { minimum: 5 }, presence: true
  validates :user, presence: true

  default_scope { order('updated_at DESC') }

  after_create :send_favorite_emails

  after_create do
    comment = Comment.find_by(id: self.id)
    hashtags = self.body.scan(/#\w+/)
    hashtags.uniq.map do |hashtag|
      tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))
      comment.tags << tag
    end
  end


  before_update do
    comment = Comment.find_by(id: self.id)
    comment.tags.clear
    hashtags = self.body.scan(/#\w+/)
    hashtags.uniq.map do |hashtag|
      tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))
      comment.tags << tag
    end
  end

  private

  def send_favorite_emails
    post.favorites.each do |favorite|
      FavoriteMailer.new_comment(favorite.user, post, self).deliver_now
    end
  end
end
