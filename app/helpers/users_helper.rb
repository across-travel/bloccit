module UsersHelper
  def find_similar_users(similar_raters)
    similar_users = []
    similar_raters.map { |user| similar_users << user if @user.following?(user) == false }
    similar_users
  end
end
