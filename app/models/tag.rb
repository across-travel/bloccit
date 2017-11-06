class Tag < ApplicationRecord
  has_many :taggings
  has_many :comments, through: :taggings, source: :taggable, source_type: :Comment
  has_many :posts, through: :taggings, source: :taggable, source_type: :Post

end
