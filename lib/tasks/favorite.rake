require 'tasks/helpers.rb'
include Helpers

namespace :db do
  namespace :seed do
    namespace :favorite do
      task :reset => :environment do
        print "Deleting favorites..."
        truncate_table("favorites")
        puts "Done"
      end
    end
  end
end
