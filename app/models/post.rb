class Post < ApplicationRecord
  searchkick word_start: [:title, :body]

  def search_data
    {
      title: title,
      body: body
    }
  end

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

  include StreamRails::Activity
  as_activity

  def activity_should_sync?
    self.topic.present? && activity_verb == "Post" ? false : true
  end

  def activity_object
    self
  end

  def activity_actor
    self.user
  end

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
    unless self.topic.nil?
      feed = StreamRails.feed_manager.get_feed("topic", self.topic.id)
      activity_data = {actor: "User:#{self.user.id}", verb: "topic_post", object: "Post:#{self.id}", target: "Topic:#{self.topic.id}", foreign_id: "post:#{self.id}"}
      activity_response = feed.add_activity(activity_data)
    end
  end

  before_destroy do
    unless self.topic.nil?
      feed = StreamRails.feed_manager.get_feed("topic", self.topic.id)
      feed.remove_activity("post:#{self.id}", foreign_id=true)
    else
      feed = StreamRails.feed_manager.get_user_feed(self.user.id)
      feed.remove_activity("Post:#{self.id}", foreign_id=true)
    end
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
      self.mentions.find_or_create_by(username: mention, mentionable: self)
      # post.mentions << username if username.persisted?
    end
  end

  before_update do
    post = Post.find_by(id: self.id)
    post.mentions.clear
    mentions = self.body.scan(/@\w+/)
    mentions.uniq.map do |mention|
      self.mentions.find_or_create_by(username: mention, mentionable: self)
      # post.mentions << username if username.persisted?
    end
  end
end
