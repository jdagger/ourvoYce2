class CreateZips < ActiveRecord::Migration
  def up
    create_table :zips do |t|
      t.string :zip
      t.string :latitude
      t.string :longitude
      t.string :city
      t.string :state
    end
  end

  def down
    drop_table :zips
  end
end
