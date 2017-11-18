require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:comment) { Comment.create!(body: 'Comment Body', post: post, user: user, commentable: post) }
  let(:tag) { create(:tag) }

  it { is_expected.to have_many(:taggings) }

  it { is_expected.to have_many(:comments).through(:taggings) }
  it { is_expected.to have_many(:posts).through(:taggings) }

  describe "taggings" do
     it "allows the same tag to be associated with a different comment and post" do
       comment.tags << tag
       post.tags << tag

       comment_tag = comment.tags[0]
       post_tag = post.tags[0]

       expect(comment_tag).to eql(post_tag)
     end
   end
end
