class User < ApplicationRecord
  recommends :topics, :posts

  before_save { self.email = email.downcase if email.present? }
  before_save { self.role ||= :member }

  before_create :generate_auth_token

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy

  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :topics, through: :subscriptions

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :username, length: { minimum: 1, maximum: 20 },
                       format: { with: /\A@[^@\s][a-zA-Z0-9\w]+\Z/ },
                       presence: true,
                       uniqueness: true

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true

  validates :password, presence: true, length: { minimum: 6 }, unless: :password_digest
  validates :password, length: { minimum: 6 }, allow_blank: true

  validates :email,
            presence: true,
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i },
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 254 }

  has_secure_password

  enum role: [:member, :admin]

  def avatar_url(size)
    gravatar_id = Digest::MD5::hexdigest(self.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end

  def generate_auth_token
    loop do
      self.auth_token = SecureRandom.base64(64)
      break unless User.find_by(auth_token: auth_token)
    end
  end

  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  def subscribe(topic)
    subscriptions.create(topic: topic)
  end

  def unsubscribe(topic)
    subscriptions.find_by(topic: topic).destroy
  end

  def subscribed_to?(topic)
    topics.include?(topic)
  end
end
