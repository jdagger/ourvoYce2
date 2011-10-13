class CreateUserVote < ActiveRecord::Migration
  def up
    create_table :user_votes do |t|
      t.integer :user_id
      t.integer :item_id
      t.integer :vote
      t.integer :lock_version, :default => 0
      t.timestamps
    end
  end

  def down
    drop_table :user_votes
  end
end
