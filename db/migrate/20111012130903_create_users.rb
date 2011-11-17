class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      #t.string :password_digest
      t.string :country
      t.string :zip
      t.string :state
      t.integer :birth_year
      t.date :member_since
      #t.boolean :confirmed

      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.confirmable

      # t.encryptable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
  end

  def down
    drop_table :users
  end
end
