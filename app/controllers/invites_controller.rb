class InvitesController < ApplicationController
  include InvitesHelper
  before_action :require_sign_in
  before_action :invite_params, only: [:create]

  def new
    @invite = Invite.new
  end

  def create
    @invite = current_user.invites.new(invite_params)
    @invite.phone = "+" + @invite.phone

    if @invite.save
      flash.now[:notice] = "#{@invite.email} has been invited to bloccit"
      render 'new'
    else
      binding.pry
      flash.now[:alert] = "#{@invite.email} has not been invite to bloccit. Please try again."
      render 'new'
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:email, :phone)
  end
end
