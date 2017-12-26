require 'rails_helper'

RSpec.describe FeedsController, type: :controller do

  describe "GET #notifications" do
    it "returns http success" do
      get :notifications
      expect(response).to have_http_status(:success)
    end
  end

end
