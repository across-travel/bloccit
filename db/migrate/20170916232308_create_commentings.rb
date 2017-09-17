class CreateCommentings < ActiveRecord::Migration[5.1]
  def change
    create_table :commentings do |t|
      t.references :comment, index: true
      t.references :commentable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
