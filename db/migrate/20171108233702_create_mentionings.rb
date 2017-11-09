class CreateMentionings < ActiveRecord::Migration[5.1]
  def change
    create_table :mentionings do |t|
      t.references :mention, index: true
      t.references :mentionable, polymorphic: true, index: true

      t.timestamps
    end
    add_foreign_key :mentionings, :mentions
  end
end
