require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:subscriber) { create(:user) }
  let(:topic) { create(:topic, user: user) }
  let(:user) { create(:user, role: :admin) }
  let(:subscription) { create(:subscription, user: subscriber, topic: topic) }

  it { is_expected.to belong_to(:topic) }
  it { is_expected.to belong_to(:user) }


  describe "attributes" do
    it "should have topic & user attributes" do
      expect(subscription).to have_attributes(user: subscriber, topic: topic)
    end
  end
end
