require 'rails_helper'

RSpec.describe Mention, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:comment) { Comment.create!(body: 'Comment Body', post: post, user: user) }
  let(:mention) { create(:mention, username: user.username) }

  it { is_expected.to have_many(:mentionings) }

  it { is_expected.to have_many(:comments).through(:mentionings) }
  it { is_expected.to have_many(:posts).through(:mentionings) }

  describe "mentionings" do
    it "allows the same mention to be associated with a different comment and post" do
      comment.mentions << mention
      post.mentions << mention

      comment_mention = comment.mentions[0]
      post_mention = post.mentions[0]

      expect(comment_mention).to eql(post_mention)
    end
  end
end
