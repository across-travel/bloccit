class PostsController < ApplicationController
  before_action :require_sign_in, except: :show
  before_action :authorize_user, except: [:show, :new, :create, :hashtags]
  before_action :topic_locate, only: [:new, :create]
  before_action :usernames_load, only: [:show, :new, :edit]

  def show
    gon.comments = Comment.where(post_id: params[:id])
    @post = Post.find(params[:id])
  end

  def new
  	@post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.topic = @topic if @topic

    if @post.save
      flash[:notice] = "Post was saved successfully."
      redirect_to [@topic, @post].compact
    else
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.assign_attributes(post_params)

    if @post.save
      flash[:notice] = "Post was updated successfully."

      redirect_to [@post.topic, @post].compact
    else
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if @post.destroy
      flash[:notice] = "\"#{@post.title}\" was deleted successfully."
      redirect_to @post.topic if @post.topic
      redirect_to posts_path if @post.topic.nil?
    else
      flash.now[:alert] = "There was an error deleting the post."
      render :show
    end
  end

  def hashtags
    tag = Tag.find_by(name: params[:name])
    @posts = tag.posts
    @comments = tag.comments
  end

  private

  def usernames_load
    gon.usernames = User.connection.select_values("SELECT username FROM users").to_json.gsub("@", "")
  end

  def topic_locate
    @topic = Topic.find(params[:topic_id]) if params[:topic_id].present?
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end

  def authorize_user
    post = Post.find(params[:id])
    unless current_user == post.user || current_user.admin?
      flash[:alert] = "You must be an admin to do that."
      redirect_to [post.topic, post]
    end
  end
end
