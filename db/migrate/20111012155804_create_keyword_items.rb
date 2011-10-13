class CreateKeywordItems < ActiveRecord::Migration
  def up
    create_table :keyword_items do |t|
      t.integer :keyword_id
      t.integer :item_id
    end
  end

  def down
    drop_table :keyword_items
  end
end
