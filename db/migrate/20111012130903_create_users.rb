class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :country
      t.string :zip
      t.string :state
      t.integer :birth_year
      t.date :member_since
      t.boolean :confirmed
    end
  end

  def down
    drop_table :users
  end
end
