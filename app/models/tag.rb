class Tag < ApplicationRecord
  searchkick word_start: [:name]

  def search_data
    {
      name: name
    }
  end

  has_many :taggings
  has_many :comments, through: :taggings, source: :taggable, source_type: :Comment
  has_many :posts, through: :taggings, source: :taggable, source_type: :Post
end
