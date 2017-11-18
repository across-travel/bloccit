class CommentsController < ApplicationController
  include CommentsHelper
  before_action :require_sign_in
  before_action :authorize_user, only: [:destroy]
  before_action :find_commentable

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.post = find_post_in_commentable(@commentable)
    @comment.user = current_user
    @new_comment = Comment.new

    # if @comment.save
    #   flash[:notice] = "Comment saved successfully."
    #   redirect_to [@comment.post.topic, @comment.post].compact
    # else
    #   flash[:alert] = "Comment failed to save."
    #   redirect_to [@comment.post.topic, @comment.post].compact
    # end
    respond_to do |format|
      format.html do
        comment_save
        redirect_to :back, fallback: root_path
      end
      format.js do
        comment_save
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    # if @comment.destroy
    #   flash[:notice] = "Comment was deleted successfully."
    #   redirect_to [@comment.post.topic, @comment.post].compact
    #  else
    #   flash[:alert] = "Comment couldn't be deleted. Try again."
    #   redirect_to [@comment.post.topic, @comment.post].compact
    # end

    respond_to do |format|
      format.html do
        comment_delete
        redirect_to :back, fallback: root_path
      end
      format.js do
        comment_delete
      end
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
