class Post < ApplicationRecord
  belongs_to :topic, optional: true
  belongs_to :user
	has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, dependent: :destroy

  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings

  has_many :mentions, as: :mentionable

  # has_many :mentionings, as: :mentionable
  # has_many :mentions, through: :mentionings

  default_scope { order('rank DESC') }

  scope :visible_to, -> (user) { user ? all : joins(:topic).where('topics.public' => true) }

  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :user, presence: true

  def up_votes
    votes.where(value: 1).count
  end

  def down_votes
    votes.where(value: -1).count
  end

  def points
    votes.sum(:value)
  end

  def update_rank
    age_in_days = (created_at - Time.new(1970,1,1)) / 1.day.seconds
    new_rank = points + age_in_days
    update_attribute(:rank, new_rank)
  end

  after_create do
    post = Post.find_by(id: self.id)
    hashtags = self.body.scan(/#\w+/)
    hashtags.uniq.map do |hashtag|
      tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))
      post.tags << tag
    end
  end


  before_update do
    post = Post.find_by(id: self.id)
    post.tags.clear
    hashtags = self.body.scan(/#\w+/)
    hashtags.uniq.map do |hashtag|
      tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))

      post.tags << tag
    end
  end

  after_create do
    post = Post.find_by(id: self.id)
    mentions = self.body.scan(/@\w+/)
    mentions.uniq.map do |mention|
      self.mentions.find_or_create_by(username: mention)
      # post.mentions << username if username.persisted?
    end
  end

  before_update do
    post = Post.find_by(id: self.id)
    post.mentions.clear
    mentions = self.body.scan(/@\w+/)
    mentions.uniq.map do |mention|
      self.mentions.find_or_create_by(username: mention)
      # post.mentions << username if username.persisted?
    end
  end
end
