class CreateFavorites < ActiveRecord::Migration
  def up
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :item_id
      t.timestamps
    end
  end

  def down
    drop_table :favorites
  end
end
