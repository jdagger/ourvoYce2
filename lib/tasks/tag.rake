require 'tasks/helpers.rb'
include Helpers

namespace :db do
  namespace :seed do
    namespace :tags do
      task :all => :environment do
        Rake::Task['db:seed:tags:reset'].invoke
        Rake::Task['db:seed:tags:create'].invoke
      end

      task :reset => :environment do
        print "Removing tag records..."
        truncate_table('tags')
        truncate_table('tag_items')
        puts "done"
      end

      task :create => :environment do
        print "Creating tag records..."
        tags_to_insert = []
        tag_section = false
        File.open("#{Rails.root}/db/tag_item_seed_data.txt", "r") do |infile|
          while (line = infile.gets)
            next if line.comment_line
            if line.section_line
              tag_section = line.tag_section_line
              next
            end
            next unless tag_section

            id, path, friendly_name, popular, hot_topic = line.to_seed_array
            tags_to_insert << "(#{id}, '#{friendly_name}', '#{path}', #{popular}, #{hot_topic})"
          end
        end

        unless tags_to_insert.blank?
          sql = "INSERT INTO tags (id, friendly_name, path, popular, hot_topic) VALUES #{tags_to_insert.join(", ")}"
          Tag.connection.execute sql
        end
        ActiveRecord::Base.connection.reset_pk_sequence!('tags')
        puts "done"
      end

    end
  end
end
