class Mention < ApplicationRecord
  has_many :mentionings
  has_many :comments, through: :mentionings, source: :mentionable, source_type: :Comment
  has_many :posts, through: :mentionings, source: :mentionable, source_type: :Post

  validates :username, presence: true
  validates :username, uniqueness: true

  validate :check_username

  def check_username
    errors.add(:base, 'User does not exist') unless User.find_by(username: self.username).present?
  end
end
