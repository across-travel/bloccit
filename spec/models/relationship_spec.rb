require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user_following) { create(:user) }
  let(:user_followed) { create(:user) }
  let(:relationship) { create(:relationship, follower_id: user_following.id, followed_id: user_followed.id) }

  it { is_expected.to belong_to(:follower) }
  it { is_expected.to belong_to(:followed) }


  describe "attributes" do
    it "should have follower & followed attributes" do
      expect(relationship).to have_attributes(follower_id: relationship.follower_id, followed_id: relationship.followed_id)
    end
  end
end
