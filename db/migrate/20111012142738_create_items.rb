class CreateItems < ActiveRecord::Migration
  def up
    create_table :items do |t|
      t.string :name
      t.string :item_type
      t.string :description
      t.string :logo
      t.boolean :hot_topic, :default => false
      t.string :wikipedia
      t.string :website
      t.integer :default_order, :default => 1000
      t.integer :lock_version, :default => 0
      t.integer :thumbs_up_vote_count, :default => 0
      t.integer :thumbs_down_vote_count, :default => 0
      t.integer :neutral_vote_count, :default => 0
      t.integer :total_vote_count, :default => 0
    end
  end

  def down
    drop_table :items
  end
end
