class SearchController < ApplicationController
  before_action :authenticate_user!

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

    @tags = if search
      Tag.search(search, fields: [:name], match: :word_start)
    end
  end

  def autocomplete
    user_json = User.search(params[:query], fields: [:name, :username], match: :word_start, limit: 2).map {|user| {store: user.name, value: user.id}}
    topic_json = Topic.search(params[:query], fields: [:name, :description], match: :word_start, limit: 2).map {|topic| {store: topic.name, value: topic.id}}
    post_json = Post.search(params[:query], fields: [:title, :body], match: :word_start, limit: 2).map {|post| {store: post.title, value: post.id}}
    tag_json = Tag.search(params[:query], fields: [:name], match: :word_start, limit: 2).map {|tag| { store: tag.name, value: tag.id }}

    render json: (user_json + topic_json + post_json + tag_json)
  end
end
