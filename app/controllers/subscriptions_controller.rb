class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @topic = Topic.find(params[:topic_id])
    current_user.subscribe(@topic)
    redirect_to @topic
  end

  def destroy
    @topic = Subscription.find(params[:id]).topic
    current_user.unsubscribe(@topic)
    redirect_to current_user
  end
end
