class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_to user
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    StreamRails.feed_manager.get_feed("timeline", current_user.id).unfollow("user", user.id)
    current_user.unfollow(user)
    redirect_to user
  end
end
