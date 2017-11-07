require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:topic) { create(:topic) }
  let(:user) { create(:user) }
  let(:post) { create(:post) }
	let(:comment) { Comment.create!(body: 'Comment Body', post: post, user: user) }

  it { is_expected.to have_many(:taggings) }
  it { is_expected.to have_many(:tags).through(:taggings) }

  it { is_expected.to belong_to(:post) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:body).is_at_least(5) }

	describe "attributes" do
		it "has a body attribute" do
			expect(comment).to have_attributes(body: "Comment Body")
		end
	end
end
