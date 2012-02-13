require 'tasks/helpers.rb'
include Helpers

namespace :db do
  namespace :seed do
    namespace :state do
      task :all => :environment do
        print "Removing state records..."
        truncate_table('states')
        puts "done"

        print "Creating state records..."
        states_to_insert = []
        File.open("#{Rails.root}/db/states.txt", "r") do |infile|
          while (line = infile.gets)
            vals = line.split('::').collect { |val| val.strip }
            id = vals[1]
            name = vals[2]
            abbreviation = vals[3]
            states_to_insert << "(#{id}, '#{name}', '#{abbreviation}')"
          end
        end

        sql = "INSERT INTO states (id, name, abbreviation) VALUES #{states_to_insert.join(", ")}"
        State.connection.execute sql
        ActiveRecord::Base.connection.reset_pk_sequence!('states')

        puts "done"
      end
    end
  end
end
