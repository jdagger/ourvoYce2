class CreateOmniauthProviders < ActiveRecord::Migration
  def change
    create_table :omniauth_providers do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.boolean :confirmed

      t.timestamps
    end
  end
end
