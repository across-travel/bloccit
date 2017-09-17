class RemovePostFromComment < ActiveRecord::Migration[5.1]
  def change
    remove_reference :comments, :post, foreign_key: true
  end
end
