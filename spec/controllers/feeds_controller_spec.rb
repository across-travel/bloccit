require 'rails_helper'


RSpec.describe FeedsController, type: :controller do
  let(:my_user) { create(:user) }

  describe "GET #notifications" do
    before do
      sign_in(my_user)
    end

    it "returns http success" do
      get :notifications
      expect(response).to have_http_status(:success)
    end
  end

end
