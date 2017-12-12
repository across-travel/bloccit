class NotificationsController < ApplicationController
  before_action :require_sign_in

  def notifications
    @user = current_user
    @notifications = @user.notifications
  end
end
