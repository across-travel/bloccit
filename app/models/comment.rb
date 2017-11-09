class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings

  has_many :mentionings, as: :mentionable
  has_many :mentions, through: :mentionings

  validates :body, length: { minimum: 5 }, presence: true
  validates :user, presence: true

  default_scope { order('updated_at DESC') }

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

  after_create do
    comment = Comment.find_by(id: self.id)
    mentions = self.body.scan(/@\w+/)
    mentions.uniq.map do |mention|
      username = Mention.find_or_create_by(username: mention)
      comment.mentions << username if username.persisted?
    end
  end


  before_update do
    comment = Comment.find_by(id: self.id)
    comment.mentions.clear
    mentions = self.body.scan(/@\w+/)
    mentions.uniq.map do |mention|
      username = Mention.find_or_create_by(username: mention)
      comment.mentions << username if username.persisted?
    end
  end
end
