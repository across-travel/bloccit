require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:my_user) { create(:user) }

  describe "GET #index" do
    before do
      sign_in(my_user)
    end

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
