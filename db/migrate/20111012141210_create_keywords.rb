class CreateKeywords < ActiveRecord::Migration
  def up
    create_table :keywords do |t|
      t.string :path
      t.string :friendly_name
    end
  end

  def down
    drop_table :keywords
  end
end
