class WelcomeController < ApplicationController
  def index
    redirect_to news_feed_path if current_user
  end

  def about
  end
end
