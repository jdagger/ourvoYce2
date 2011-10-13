class CreateStats < ActiveRecord::Migration
  def up
    create_table :stats do |t|
      t.integer :item_id
      t.integer :birth_year
      t.string :state
      t.string :zip
      t.integer :lock_version, :default => 0
      t.integer :thumbs_up_vote_count, :default => 0
      t.integer :thumbs_down_vote_count, :default => 0
      t.integer :neutral_vote_count, :default => 0
      t.integer :total_vote_count, :default => 0
    end
  end

  def down
    drop_table :stats
  end
end
