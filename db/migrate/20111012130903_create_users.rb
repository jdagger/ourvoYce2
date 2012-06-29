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

      #t.database_authenticatable :null => false
      t.string :email, :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      #t.recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      #t.rememberable
      t.datetime :remember_created_at

      #t.trackable
      t.integer :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      #t.confirmable
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email

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
