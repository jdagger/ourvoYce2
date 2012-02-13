require 'tasks/helpers.rb'
include Helpers

namespace :db do
  namespace :seed do
    namespace :zip do
      task :all => :environment do
        print "Cleaning zip table..."
        truncate_table('zips')
        puts "done"

        print "Creating zips..."
        zip_inserts = []
        File.open("#{Rails.root}/db/zips.txt", "r") do |infile|
          while (line = infile.gets)
            vals = line.split('::').collect { |val| val.strip }
            zip = vals[1]
            state = vals[2]
            latitude = vals[3]
            longitude = vals[4]
            zip_inserts << "('#{zip}', '#{state}', '#{latitude}', '#{longitude}', '')"
          end
        end
        sql = "INSERT INTO zips (zip, state, latitude, longitude, city) VALUES #{zip_inserts.join(", ")}"
        Zip.connection.execute sql
        ActiveRecord::Base.connection.reset_pk_sequence!('zips')
        puts "done"
      end
    end
  end
end
