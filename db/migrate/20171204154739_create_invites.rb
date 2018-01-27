class CreateInvites < ActiveRecord::Migration[5.1]
  def change
    create_table :invites do |t|
      t.integer :user_id
      t.string :phone
      t.string :email

      t.timestamps
    end

    add_index :invites, :user_id
  end
end
