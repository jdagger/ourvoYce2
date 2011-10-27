class CreateStates < ActiveRecord::Migration
  def up
    create_table :states do |t|
      t.string :name
      t.string :abbreviation
    end
  end

  def down
    drop_table :states
  end
end
