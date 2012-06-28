require 'tasks/helpers.rb'
include Helpers

namespace :db do
  namespace :seed do
    namespace :user do
      task :all => :environment do
        puts "Rebuilding full user table"
        Rake::Task['db:seed:user:reset'].invoke
        Rake::Task['db:seed:user:create_default_user'].invoke
      end

      desc "Delete user table"
      task :reset => :environment do
        print "Deleting user tables..."
        truncate_table('users')
        truncate_table('user_tokens')
        puts "done"
      end

      desc "Seeding default user"
      task :create_default_user => :environment do
        print "Seeding default Users..."

        user = User.new(
          :email => 'ryan@ourvoyce.com', 
          :password => 'vq4F3[L/Ka_u', 
          :zip => '28801', 
          :birth_year => 1980,
          :country => 'United States',
          :state => 'NC'
        )
        user.confirmed_at = Time.now
        user.member_since = Time.now
        user.save

        user = User.new(
          :email => 'jon@ourvoyce.com', 
          :password => '2c&F62YqO6pZ', 
          :zip => '28787', 
          :birth_year => 1975,
          :country => 'United States',
          :state => 'NC'
        )
        user.confirmed_at = Time.now
        user.member_since = Time.now
        user.save

        puts "done"
      end

    end
  end
end
