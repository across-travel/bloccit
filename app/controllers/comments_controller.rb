class CommentsController < ApplicationController
  before_action :require_sign_in
  before_action :authorize_user, only: [:destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    @new_comment = Comment.new

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
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

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
