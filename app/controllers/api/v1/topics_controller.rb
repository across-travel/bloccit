class Api::V1::TopicsController < Api::V1::BaseController
  before_action :authenticate_user, except: [:index, :show]
  before_action :authorize_user, except: [:index, :show]

  def index
    topics = Topic.all
    render json: topics, status: 200
  end

  def show
    topics_posts = Topic.find(params[:id]).posts.all
    render json: topics_posts, status: 200
  end
end
