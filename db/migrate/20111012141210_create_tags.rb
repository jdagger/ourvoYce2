class CreateTags < ActiveRecord::Migration
  def up
    create_table :tags do |t|
      t.string :path
      t.string :friendly_name
      t.boolean :popular, :default => false
      t.boolean :hot_topic, :default => false
    end
  end

  def down
    drop_table :tags
  end
end
