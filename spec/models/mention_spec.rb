require 'rails_helper'

RSpec.describe Mention, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:comment) { Comment.create!(body: 'Comment Body', post: post, user: user, commentable: post) }

  describe "mentions" do
    it "creates a mention associated to a comment" do
      mention = comment.mentions.create(username: user.username)
      expect(mention.mentionable).to eql(comment)
    end

    it "creates a mention associated to a post" do
      mention = post.mentions.create(username: user.username)
      expect(mention.mentionable).to eql(post)
    end
  end
end
