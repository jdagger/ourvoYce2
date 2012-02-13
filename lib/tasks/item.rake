require 'tasks/helpers.rb'
include Helpers

namespace :db do
  namespace :seed do
    namespace :items do
      task :all => :environment do
        Rake::Task['db:seed:items:reset'].invoke
        Rake::Task['db:seed:items:create'].invoke
      end

      task :reset => :environment do
        print "Deleting all items..."
        truncate_table('items')
        truncate_table('tag_items')
        puts "done"
      end

      task :create => :environment do
        print "Creating item records..."
        items_to_insert = []
        item_tags_to_insert = []
        item_section = false
        File.open("#{Rails.root}/db/tag_item_seed_data.txt", "r") do |infile|
          while (line = infile.gets)
            next if line.comment_line
            if line.section_line
              item_section = line.item_section_line
              next
            end
            next unless item_section

            id, name, description, item_type, logo, website, wikipedia, default_order, tags = line.to_seed_array
            items_to_insert << "(#{id}, '#{name}', '#{description}', '#{item_type}', '#{logo}', '#{website}', '#{wikipedia}', #{default_order})"

            unless tags.blank?
              #Tags are stored as comma seperated list of tag_ids. Append item_id, tag_id to array for later insertion
              item_tags_to_insert << tags.split(',').map{|x| "(#{id}, #{x})" }
            end

          end
        end

        unless items_to_insert.blank?
          sql = "INSERT INTO items (id, name, description, item_type, logo, website, wikipedia, default_order) VALUES #{items_to_insert.join(", ")}"
          Item.connection.execute sql
          ActiveRecord::Base.connection.reset_pk_sequence!('items')
        end

        if item_tags_to_insert.length > 0
          sql = "INSERT INTO tag_items (item_id, tag_id) VALUES #{item_tags_to_insert.join(", ")}"
          TagItem.connection.execute sql
          ActiveRecord::Base.connection.reset_pk_sequence!('tag_items')
        end

        #Rake::Task['db:seed:items:create'].reenable() 
        puts "Done"
      end
    end

  end
end
