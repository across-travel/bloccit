require 'rails_helper'
include SessionsHelper

RSpec.describe SubscriptionsController, type: :controller do
  let(:subscriber) { create(:user) }
  let(:topic) { create(:topic) }
  let(:subscription) { create(:subscription, topic_id: topic.id, user_id: subscriber.id) }

  describe "not signed in" do
    it "redirects #create to login page" do
      post :create, params: {subscription: subscription}
      expect(response).to redirect_to(new_session_path)
    end

    it "redirects #destroy to login page" do
      delete :destroy, params: {id: subscription.id}
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "not signed in" do
    before do
      create_session(subscriber)
    end

    it "redirects #create to topic page" do
      post :create, params: {topic_id: topic.id, subscription: { user_id: subscriber.id } }
      expect(response).to redirect_to topic
    end

    it "redirects #destroy to user profile page" do
      delete :destroy, params: {id: subscription.id}
      expect(response).to redirect_to subscriber
    end
  end

end
