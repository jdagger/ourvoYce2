require 'tasks/helpers.rb'
include Helpers

namespace :db do
  namespace :seed do
    namespace :user do
      task :all => :environment do
        puts "Rebuilding full user table"
        Rake::Task['db:seed:user:reset'].invoke
        Rake::Task['db:seed:user:create_default_user'].invoke
        Rake::Task['db:seed:user:create_random_users'].invoke
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
        print "Seeding default User..."

        user = User.new(
          :email => 'ryan@ourvoyce.com', 
          :password => 'test123', 
          :zip => '28801', 
          :birth_year => 1950,
          :country => 'United States',
          :state => 'NC'
        )
        user.confirmed_at = Time.now
        user.member_since = Time.now
        user.save

        user = User.new(
          :email => 'jon@ourvoyce.com', 
          :password => 'test123', 
          :zip => '28801', 
          :birth_year => 1950,
          :country => 'United States',
          :state => 'NC'
        )
        user.confirmed_at = Time.now
        user.member_since = Time.now
        user.save

        user = User.new(
          :email => 'test@ourvoyce.com', 
          :password => 'test123', 
          :zip => '28801', 
          :birth_year => 1970,
          :country => 'United States',
          :state => 'NC'
        )
        user.confirmed_at = Time.now
        user.member_since = Time.now
        user.save

        puts "done"
      end

      desc "Create random users"
      task :create_random_users => :environment do |t, args|

        users_to_create = 1000

        puts "Creating #{users_to_create} user records"

        print "Loading zips..."
        zips = Zip.select([:zip, :state]).to_a
        puts "done"

        print "Creating random user records..."

        users_to_insert = []
        (1..users_to_create).each do |i|
          random_zip = zips.sample
          email = "test_#{i}@ourvoyce.com"
          birth_year = (1930..1990).to_a.sample
          users_to_insert << "('#{email}', '#{random_zip[:zip]}', '#{random_zip[:state]}', #{birth_year})"
        end
        sql = "INSERT INTO users (email, zip, state, birth_year) VALUES #{users_to_insert.join(", ")}"
        User.connection.execute sql
        ActiveRecord::Base.connection.reset_pk_sequence!('users')
        puts "done"

      end
    end
  end
end
