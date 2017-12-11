class Topic < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions

  validate :check_role

  def check_role
    errors.add(:base, 'User is not an admin') unless self.user.role == 'admin'
  end

  scope :visible_to, -> (user) { user ? all : where(public: true) }
end
