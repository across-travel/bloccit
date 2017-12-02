class InvitesController < ApplicationController
  include InvitesHelper
  before_action :user_params, only: [:create]

  def new
    @new_user = User.new
  end

  def create
    @new_user = User.new(user_params)
    @user = current_user

    if isEmail(@new_user.email) && @user.valid?
      InviteMailer.invite_user(@new_user, @user).deliver_now
      flash.now[:notice] = "#{@new_user.email} has been invited to bloccit"
      render 'new'
    else
      flash.now[:alert] = "#{@new_user.email} has not been invite to bloccit. Please try again."
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
