class CommentsController < ApplicationController
  before_action :require_sign_in
  before_action :authorize_user, only: [:destroy]

  def create
    @parent = parent
    comment = Comment.new(comment_params)
    comment.user = current_user
    @parent.comments << comment

    if comment.save
      flash[:notice] = "Comment saved successfully."
      redirect_to parent_path
    else
      flash[:alert] = "Comment failed to save."
      redirect_to parent_path
    end
  end

  def destroy
    @parent = parent
    comment = @parent.comments.find(params[:id])

    if comment.destroy
      flash[:notice] = "Comment was deleted successfully."
      redirect_to parent_path
     else
      flash[:alert] = "Comment couldn't be deleted. Try again."
      redirect_to parent_path
    end
  end

  private

  def parent
    params[:topic_id] ? Topic.find(params[:topic_id]) : Post.find(params[:post_id])
  end

  def parent_path
    params[:post_id] ? [parent.topic, parent] : parent
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authorize_user
    comment = Comment.find(params[:id])
    unless current_user == comment.user || current_user.admin?
      flash[:alert] = "You do not have permission to delete a comment."
      redirect_to [comment.post.topic, comment.post]
    end
  end
end
