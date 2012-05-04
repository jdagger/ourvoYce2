class CreateSuggestTopics < ActiveRecord::Migration
  def up
    create_table :suggest_topics do |t|
      t.integer :user_id
      t.string :ip
      t.string :topic
      t.timestamps
    end
  end

  def down
    drop_table :suggest_topics
  end
end
