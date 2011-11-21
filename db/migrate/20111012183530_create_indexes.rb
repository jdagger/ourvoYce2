class CreateIndexes < ActiveRecord::Migration
  def up
    add_index :tags, :path, :unique => true
    add_index :tags, :friendly_name, :unique => true
    add_index :stats, [:item_id, :birth_year, :zip], :unique => true
    add_index :user_votes, [:item_id, :user_id], :unique => true
    add_index :zips, :zip
  end

  def down
    remove_index :stats, [:item_id, :birth_year, :zip]
    remove_index :user_votes, [:item_id, :user_id]
    remove_index :zips, :zip
    remove_index :tags, :path
    remove_index :tags, :friendly_name
  end
end
