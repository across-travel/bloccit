require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  let(:user_following) { create(:user) }
  let(:user_followed) { create(:user) }
  let(:relationship) { create(:relationship, follower_id: user_following.id, followed_id: user_followed.id) }

  describe "not signed in" do
    it "redirects #create to login page" do
      post :create, params: {relationship: relationship}
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects #destroy to login page" do
      delete :destroy, params: {id: relationship.id}
      expect(response).to redirect_to(new_user_session_path)
    end
  end

end
