require 'tasks/helpers.rb'
include Helpers
namespace :db do
  namespace :seed do
    namespace :stat do
      task :reset => :environment do
        print "Deleting all vote stats..."
        truncate_table("stats")
        puts "Done"
      end
    end
  end
end
