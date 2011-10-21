class CreateTagItems < ActiveRecord::Migration
  def up
    create_table :tag_items do |t|
      t.integer :tag_id
      t.integer :item_id
    end
  end

  def down
    drop_table :tag_items
  end
end
