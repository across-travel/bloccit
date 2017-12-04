require 'rails_helper'
include SessionsHelper

RSpec.describe InvitesController, type: :controller do
  let(:my_user) { create(:user) }

  describe "GET #new" do
    before do
      create_session(my_user)
    end

    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

end
