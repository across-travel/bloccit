class Api::V1::PostsController < Api::V1::BaseController
  before_action :authenticate_user, except: [:index, :show]
  before_action :authorize_user, except: [:index, :show]

  def index
    posts = Post.all
    render json: posts, status: 200
  end

  def show
    posts_comments = Post.find(params[:id]).comments.all
    render json: posts_comments, status: 200
  end
end
