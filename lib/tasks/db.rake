require 'tasks/helpers.rb'
include Helpers

namespace :db do
  desc "Drop, create, migrate, seed"
  task :full_reset => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
  end

  namespace :seed do
    desc "Seed all data"
    task :all => :environment do
      Rake::Task['db:seed:stat:reset'].invoke
      Rake::Task['db:seed:favorite:reset'].invoke
      Rake::Task['db:seed:user_vote:reset'].invoke

      Rake::Task['db:seed:state:all'].invoke
      Rake::Task['db:seed:zip:all'].invoke
      Rake::Task['db:seed:user:all'].invoke
      Rake::Task['db:seed:tags:all'].invoke
      Rake::Task['db:seed:items:all'].invoke

    end
  end
end
