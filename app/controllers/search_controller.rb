class SearchController < ApplicationController
  def index
    search = params[:term].present? ? params[:term] : nil
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
    render json: Searchkick.search(params[:term], index_name: [User, Topic, Post], match: :word_start)
  end
end
