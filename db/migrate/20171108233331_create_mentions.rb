class CreateMentions < ActiveRecord::Migration[5.1]
  def change
    create_table :mentions do |t|
      t.string :username
      t.references :mentionable, polymorphic: true, index: true

      t.timestamps
    end
    add_index :mentions, :username, unique: true
  end
end
