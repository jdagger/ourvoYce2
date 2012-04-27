class AddQrLookups < ActiveRecord::Migration
  def up
    create_table :qr_lookups do |t|
      t.string :code
      t.string :destination
      t.string :notes
      t.integer :counter, :default => 0
    end
  end

  def down
    remove_table :qr_lookups
  end
end
