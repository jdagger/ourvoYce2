require 'tasks/helpers.rb'
include Helpers

namespace :db do
  namespace :seed do
    namespace :user_vote do
      task :reset => :environment do
        print "Deleting all user vote..."
        truncate_table('user_votes')
        puts "Done"
      end
    end
  end
end

