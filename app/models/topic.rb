class Topic < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :labelings, as: :labelable
  has_many :labels, through: :labelings
  has_many :commentings, as: :commentable, dependent: :destroy
  has_many :comments, through: :commentings, dependent: :destroy
end
