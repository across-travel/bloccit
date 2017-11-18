module CommentsHelper
  def user_is_authorized_for_comment?(comment)
    current_user && (current_user == comment.user || current_user.admin?)
  end

  def find_post_in_commentable(commentable)
    post_parent = commentable
    until post_parent.instance_of? Post
      post_parent = post_parent.commentable
    end
    post_parent
  end
end
