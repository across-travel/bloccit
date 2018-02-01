class InvitesController < ApplicationController
  include InvitesHelper
  before_action :authenticate_user!
  before_action :invite_params, only: [:create]

  def new
    @invite = Invite.new
    @contacts = request.env['omnicontacts.contacts']

    if !@contacts.nil?
      @email_contacts = []
      @contacts.map { |c| @email_contacts << c if c[:email].present? }
      binding.pry
      @email_contacts.each do |c|
        current_user.invites.create!(email: c[:email])
      end
      flash.now[:notice] = "Your invitations have been sent successfully" unless @email_contacts.empty?
      flash.now[:alert] = "You have no contacts (with emails) for us to invite" if @email_contacts.empty?
      render :new
    end
  end

  def create
    @invite = current_user.invites.new(invite_params)
    @invite.phone = "+" + @invite.phone if @invite.phone.present?

    if @invite.save
      flash.now[:notice] = "#{@invite.email} has been invited to bloccit"
      render 'new'
    else
      flash.now[:alert] = "#{@invite.email} has not been invite to bloccit. Please try again."
      render 'new'
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:email, :phone)
  end
end
