class SearchController < ApplicationController
  def index
    search = params[:query].present? ? params[:query] : nil
    @users = if search
      User.search(search, fields: [:name, :username], match: :word_start)
    end

    @topics = if search
      Topic.search(search, fields: [:name, :description], match: :word_start)
    end

    @posts = if search
      Post.search(search, fields: [:title, :body], match: :word_start)
    end
  end

  def autocomplete
    user_json = User.search(params[:query], fields: [:name, :username], match: :word_start, limit: 2)
    # topic_json = Topic.search(params[:query], fields: [:name, :description], match: :word_start, limit: 2)
    # post_json = Post.search(params[:query], fields: [:title, :body], match: :word_start, limit: 2)

    render json: user_json
  end
end
