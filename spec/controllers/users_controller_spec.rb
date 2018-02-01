require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:new_user_attributes) do
    {
        name: "BlocHead",
        username: "Bloc_head",
        email: "blochead@bloc.io",
        password: "blochead",
        password_confirmation: "blochead"
    }
  end

  describe "not signed in" do
    let(:factory_user) { create(:user) }

    it "returns http success" do
      get :show, params: {id: factory_user.id}
      expect(response).to have_http_status(:success)
    end

    it "renders the #show view" do
      get :show, params: {id: factory_user.id}
      expect(response).to render_template :show
    end

    it "assigns factory_user to @user" do
      get :show, params: { id: factory_user.id}
      expect(assigns(:user)).to eq(factory_user)
    end

    it "should redirect following" do
      get :following, params: { id: factory_user.id }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "should redirect followers" do
      get :followers, params: { id: factory_user.id }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
