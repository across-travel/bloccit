class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.string :name, unique: true
      t.boolean :public, default: true
      t.text :description

      t.timestamps
    end
  end
end
