class UsersController < ApplicationController
  include UsersHelper
  before_action :require_sign_in, only: [:following, :followers]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.visible_to(current_user)
    @votes = @user.votes.where(value: 1)
    @comments = @user.comments
    @similar_raters = find_similar_users(@user.similar_raters)[0..2]
    @collection = single_collection(@posts, @votes, @comments)
  end

  def create
    @user = User.new
    @user.name = params[:user][:name]
    @user.username = "@" + params[:user][:username]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.save
      flash[:notice] = "Welcome to Bloccit #{@user.name}!"
      create_session(@user)
      redirect_to root_path
    else
      flash.now[:alert] = "There was an error creating your account. Please try again."
      render :new
    end
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  def subscriptions
    @title = "Subscriptions"
    @user  = User.find(params[:id])
    @subscriptions = @user.subscriptions
    render 'show_subscriptions'
  end

  def public
    if current_user.update_attributes(private: false)
      flash[:notice] = "Your account is visible to everyone."
      redirect_to current_user
    else
      flash[:alert] = "There was an error making your account public. Please try again."
      redirect_to current_user
    end
  end

  def private
    if current_user.update_attributes(private: true)
      flash[:notice] = "Your account is only visible to you and your followers."
      redirect_to current_user
    else
      flash[:alert] = "There was an error making your account private. Please try again."
      redirect_to current_user
    end
  end

  private

  def single_collection(posts, votes, comments)
    collection = []
    posts.map{ |post| collection << post }
    votes.map{ |vote| collection << vote }
    comments.map{ |comment| collection << comment }

    collection.sort_by do |collection|
      if collection.instance_of?(Post) || collection.instance_of?(Comment)
        collection.created_at
      else
        collection.updated_at
      end
    end.reverse
  end
end
