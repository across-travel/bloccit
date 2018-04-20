class Tag < ApplicationRecord
  searchkick word_start: [:name], settings: {number_of_shards: 1, number_of_replicas: 0}

  def search_data
    {
      name: name
    }
  end

  has_many :taggings
  has_many :comments, through: :taggings, source: :taggable, source_type: :Comment
  has_many :posts, through: :taggings, source: :taggable, source_type: :Post
end
