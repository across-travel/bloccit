class CommentsController < ApplicationController
  include CommentsHelper
  before_action :authenticate_user!
  before_action :authorize_user, only: [:destroy]
  before_action :find_commentable

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.post = find_post_in_commentable(@commentable)
    @comment.user = current_user
    @new_comment = Comment.new

    comment_save

    respond_to do |format|
      format.html { redirect_to :back, fallback: root_path }
      format.js
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comments = @comment.find_nested_comments

    comment_delete

    respond_to do |format|
      format.html { redirect_to :back, fallback: root_path }
      format.js
    end
  end

  private

  def find_commentable
    @commentable = Comment.find(params[:comment_id]) if params[:comment_id]
    @commentable = Post.find(params[:post_id]) if params[:post_id]
  end

  def comment_save
    if @comment.save
      flash.now[:notice] = "Comment saved successfully."
    else
      flash.now[:alert] = "Comment failed to save."
    end
  end

  def comment_delete
    if @comment.destroy
      flash.now[:notice] = "Comment was deleted successfully."
    else
      flash.now[:alert] = "Comment couldn't be deleted. Try again."
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_user
    comment = Comment.find(params[:id])
    unless current_user == comment.user || current_user.admin?
      flash[:alert] = "You do not have permission to delete a comment."
      redirect_to [comment.post.topic, comment.post].compact
    end
  end
end
