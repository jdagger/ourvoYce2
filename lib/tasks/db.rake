namespace :db do
  namespace :seed do

    desc "Seed all data"
    task :all => :environment do
      Rake::Task['db:seed:keyword:all'].invoke
      Rake::Task['db:seed:zip:all'].invoke
      Rake::Task['db:seed:user:all'].invoke
      Rake::Task['db:seed:item:all'].invoke
    end

    namespace :item do
      task :all => :environment do
        Rake::Task['db:seed:item:reset'].invoke
        Rake::Task['db:seed:media:create'].invoke
        Rake::Task['db:seed:senate:create'].invoke
        Rake::Task['db:seed:house:create'].invoke
        Rake::Task['db:seed:executive:create'].invoke
        Rake::Task['db:seed:fortune500:create'].invoke
        Rake::Task['db:seed:agency:create'].invoke
      end

      task :reset => :environment do
        print "Deleting all items..."
        Item.delete_all
        puts "done"
      end

      task :reset_by_type, [:type] => :environment do |t, args|
        type = args[:type]
        print "Deleting all #{type}..."
        Item.delete_all("item_type='#{type}'")
        puts "done"
      end

      task :insert_items, [:item_arr] => :environment do |t, args|
        items_to_insert = []
        ids = []
        keywords_to_insert = []
        args[:item_arr].each do |item|
          id = item[:id]
          name = item[:name].gsub(/'/, "''")
          logo = item[:logo].gsub(/'/, "''")
          website = item[:website].gsub(/'/, "''")
          wikipedia = item[:wikipedia].gsub(/'/, "''")
          type = item[:type].gsub(/'/, "''")
          default_order = item[:default_order]
          ids << id
          if item.has_key? :keywords
            keywords = item[:keywords].split(',').collect { |val| val.strip }
            keywords.each do |keyword|
              keywords_to_insert << "(#{id}, #{keyword})"
            end
          end
          items_to_insert << "(#{id}, '#{name}', '#{logo}', '#{website}', '#{wikipedia}', '#{type}', #{default_order})"
        end

        sql = "INSERT INTO items (id, name, logo, website, wikipedia, item_type, default_order) VALUES #{items_to_insert.join(", ")}"
        Item.connection.execute sql

        if keywords_to_insert.length > 0
          #First, remove all existing keywords for item
          sql = "DELETE FROM keyword_items WHERE item_id IN (#{ids.join(", ")})"
          KeywordItem.connection.execute sql

          sql = "INSERT INTO keyword_items (item_id, keyword_id) VALUES #{keywords_to_insert.join(", ")}"
          KeywordItem.connection.execute sql
        end

        #Might be a better way to do this
        #Ideally, can inspect self to reenable
        Rake::Task['db:seed:item:insert_items'].reenable() 
      end
    end

    namespace :senate do
      task :all => :environment do
        Rake::Task['db:seed:senate:reset'].invoke
        Rake::Task['db:seed:senate:create'].invoke
      end

      task :reset => :environment do
        Rake::Task['db:seed:item:reset_by_type'].invoke('senate')
      end

      task :create => :environment do
        print 'Inserting senators...'
        items = []
        File.open("#{Rails.root}/db/senate.txt", "r") do |infile|
          while (line = infile.gets)
            vals = line.split('::').collect { |val| val.strip }
            id = vals[1]
            name = "#{vals[2]} #{vals[4]}"
            #title = vals[5]
            #party = vals[6]
            #seat = vals[7]
            #gender = vals[8]
            #phone = vals[9]
            website = vals[10]
            wikipedia = vals[11]
            logo = vals[12]
            #display_order = vals[13]
            #branch = vals[14]
            #data1 = vals[15]
            #data2 = vals[16]
            state = vals[17]
            keywords = vals[18]

            items << {id: id, name: name, logo: logo, website: website, wikipedia: wikipedia, type: 'senate', keywords: keywords, default_order: 1000}

          end
        end

        Rake::Task['db:seed:item:insert_items'].invoke(items)
        puts "done"
      end
    end

    namespace :house do
      task :all => :environment do
        Rake::Task['db:seed:house:reset'].invoke
        Rake::Task['db:seed:house:create'].invoke
      end

      task :reset => :environment do
        Rake::Task['db:seed:item:reset_by_type'].invoke('house')
      end

      task :create => :environment do
        print 'Inserting house...'
        #Insert House records
        items = []
        File.open("#{Rails.root}/db/house.txt", "r") do |infile|
          while (line = infile.gets)
            vals = line.split('::').collect { |val| val.strip }
            id = vals[1]
            name = "#{vals[2]} #{vals[4]}"
            #title = vals[5]
            #party = vals[6]
            #district = vals[7]
            #gender = vals[8]
            #phone = vals[9]
            website = vals[10]
            wikipedia = vals[11]
            logo = vals[12]
            #display_order = vals[13]
            #branch = vals[14]
            #data1 = vals[15]
            #data2 = vals[16]
            state = vals[17]
            keywords = vals[18]
            items << { id: id, name: name, logo: logo, website: website, wikipedia: wikipedia, type: 'house', keywords: keywords, default_order: 1000 }
          end
        end
        Rake::Task['db:seed:item:insert_items'].invoke(items)
        puts "done"
      end
    end

    namespace :executive do
      task :all => :environment do
        Rake::Task['db:seed:executive:reset'].invoke
        Rake::Task['db:seed:executive:create'].invoke
      end

      task :reset => :environment do
        Rake::Task['db:seed:item:reset_by_type'].invoke('executive')
      end

      task :create => :environment do
        print 'Inserting executive...'

        #Insert executive records
        items = []
        File.open("#{Rails.root}/db/executive.txt", "r") do |infile|
          while (line = infile.gets)
            vals = line.split('::').collect { |val| val.strip }
            id = vals[1]
            name = "#{vals[2]} #{vals[3]}"
            #title = vals[4]
            website = vals[5]
            wikipedia = vals[6]
            logo = vals[7]
            default_order = vals[8]
            #branch = vals[9]
            #data1 = vals[10]
            #data2 = vals[11]
            keywords = vals[12]
            items << { id: id, name: name, default_order: default_order, logo: logo, website: website, wikipedia: wikipedia, type: 'executive', keywords: keywords }
          end
        end
        Rake::Task['db:seed:item:insert_items'].invoke(items)
        puts "done"
      end
    end

    namespace :fortune500 do
      task :all => :environment do
        Rake::Task['db:seed:fortune500:reset'].invoke
        Rake::Task['db:seed:fortune500:create'].invoke
      end

      task :reset => :environment do
        Rake::Task['db:seed:item:reset_by_type'].invoke('fortune500')
      end

      task :create => :environment do
        print 'Inserting fortune 500...'

        #Insert Fortune 500 companies

        items = []
        File.open("#{Rails.root}/db/fortune_500.txt", "r") do |infile|
          while (line = infile.gets)
            vals = line.split('::').collect { |val| val.strip }
            id = vals[1]
            name = vals[2]
            logo = vals[3]
            revenue = vals[4]
            profit = vals[5]
            website = vals[6]
            wikipedia = vals[7]
            keywords = vals[10]
            items << { id: id, name: name, logo: logo, website: website, wikipedia: wikipedia, type: 'fortune500', keywords: keywords, default_order: 1000}
          end
        end

        Rake::Task['db:seed:item:insert_items'].invoke(items)
        puts "done"
      end
    end

    namespace :agency do
      task :all => :environment do
        Rake::Task['db:seed:agency:reset'].invoke
        Rake::Task['db:seed:agency:create'].invoke
      end

      task :reset => :environment do
        Rake::Task['db:seed:item:reset_by_type'].invoke('agency')
      end

      task :create => :environment do
        print 'Inserting agency...'

        #Insert Government Agencies
        items = []

        File.open("#{Rails.root}/db/agencies.txt", "r") do |infile|
          while (line = infile.gets)
            vals = line.split('::').collect { |val| val.strip }
            id = vals[1]
            name = vals[2]
            website = vals[3]
            wikipedia = vals[4]
            logo = vals[5]
            keywords = vals[6]
            items << { id: id, name: name, logo: logo, website: website, wikipedia: wikipedia, type: 'agency', keywords: keywords, default_order: 1000 }
          end
        end
        Rake::Task['db:seed:item:insert_items'].invoke(items)
        puts "done"

      end
    end


    namespace :media do
      task :all => :environment do
        Rake::Task['db:seed:media:reset'].invoke
        Rake::Task['db:seed:media:create'].invoke
      end

      task :reset => :environment do
        Rake::Task['db:seed:item:reset_by_type'].invoke('media')
      end

      task :create => :environment do
        print "Inserting media..."
        items = []
        File.open("#{Rails.root}/db/media.txt", "r") do |infile|
          while (line = infile.gets)
            vals = line.split('::').collect { |val| val.strip }
            id = vals[1]
            name = vals[2]
            #media_type = vals[3]
            website = vals[4]
            logo = vals[5]
            #parent_id = vals[6]
            wikipedia = vals[7]
            keywords = vals[9]

            items << {id: id, name: name, logo: logo, website: website, wikipedia: wikipedia, type: 'media', keywords: keywords, default_order: 1000}
          end
        end

        Rake::Task['db:seed:item:insert_items'].invoke(items)
        puts "done"
      end
    end


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
        User.delete_all
        puts "done"
      end

      desc "Seeding default user"
      task :create_default_user => :environment do
        print "Seeding default User..."
        User.create(
          :email => 'test', 
          :password => 'test', 
          :zip => '28801', 
          :state => 'NC', 
          :birth_year => 1970,
        )
        puts "done"
      end

      desc "Create random users"
      task :create_random_users, [:users_to_create] => :environment do |t, args|
        args.with_defaults(:users_to_create => 1000)

        users_to_create = args[:users_to_create].to_i

        puts "Creating #{users_to_create} user records"

        print "Loading zips..."
        zips = Zip.select([:zip, :state]).to_a
        puts "done"

        print "Creating random user records..."

        users_to_insert = []
        (1..users_to_create).each do
          random_zip = zips.sample
          email = Forgery(:internet).email_address
          password = Forgery(:basic).password
          birth_year = (1930..1990).to_a.sample

          users_to_insert << "('#{email}', '#{password}', '#{random_zip[:zip]}', '#{random_zip[:state]}', #{birth_year})"
          #User.create(
          #email: email,
          #password: password,
          #zip: random_zip[:zip],
          #state: random_zip[:state],
          #birth_year: birth_year
          #)

        end
        sql = "INSERT INTO users (email, password_digest, zip, state, birth_year) VALUES #{users_to_insert.join(", ")}"
        User.connection.execute sql
        puts "done"

      end
    end

    namespace :keyword do
      task :all => :environment do
        print "Removing keyword records..."
        Keyword.delete_all
        puts "done"

        print "Creating keyword records..."
        keywords_to_insert = []
        File.open("#{Rails.root}/db/keywords.txt", "r") do |infile|
          while (line = infile.gets)
            vals = line.split('::').collect { |val| val.strip }
            id = vals[1]
            friendly_name = vals[2]
            path = vals[3]
            keywords_to_insert << "(#{id}, '#{friendly_name}', '#{path}')"
          end
        end

        sql = "INSERT INTO keywords (id, friendly_name, path) VALUES #{keywords_to_insert.join(", ")}"
        Keyword.connection.execute sql
        puts "done"
      end
    end

    namespace :zip do
      task :all => :environment do
        print "Cleaning zip table..."
        Zip.delete_all
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
        puts "done"
      end
    end
  end
end
