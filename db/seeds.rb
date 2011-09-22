require 'mongo'

#db = Mongo::Connection.new.db("ourvoyce")
db = Mongo::Connection.new("localhost", "27017", :safe => true).db("ourvoyce")


#Setup keywords
db[:keywords].remove({})

keywords = []
File.open("#{Rails.root}/db/keywords.txt", "r") do |infile|
  while (line = infile.gets)
    vals = line.split('::').collect { |val| val.strip }
    friendly_name = vals[2]
    path = vals[3]
    keywords << {
      friendly_name: 
      friendly_name, 
      path: path}
  end
end

db[:keywords].insert(keywords)



#Setup Items
db[:items].remove({})

#Setup media
medias = []

File.open("#{Rails.root}/db/media.txt", "r") do |infile|
  while (line = infile.gets)
    vals = line.split('::').collect { |val| val.strip }
    id = vals[1]
    name = vals[2]
    media_type = vals[3]
    website = vals[4]
    logo = vals[5]
    parent_id = vals[6]
    wikipedia = vals[7]

    medias << {
      name: name, 
      logo: logo, 
      website: website, 
      wikipedia: wikipedia, 
      type: 'Media'
    }

  end
end

db[:items].insert(medias)

#Update media keywords
media_ids = []
db[:items].find({type: 'Media'}).each do |media|
  media_ids << media['_id']
end

media = db[:keywords].find_one({friendly_name: 'Media'})
media[:item_ids] = media_ids
db[:keywords].save(media)



#Senators
senators = []
File.open("#{Rails.root}/db/senate.txt", "r") do |infile|
  while (line = infile.gets)
    vals = line.split('::').collect { |val| val.strip }
    name = "#{vals[1]} #{vals[3]}"
    #title = vals[4]
    #party = vals[5]
    #seat = vals[6]
    #gender = vals[7]
    #phone = vals[8]
    website = vals[9]
    wikipedia = vals[10]
    logo = vals[11]
    #display_order = vals[12]
    #branch = vals[13]
    #data1 = vals[14]
    #data2 = vals[15]
    state = vals[16]

    senators << {
      name: name, 
      logo: logo, 
      website: website, 
      wikipedia: wikipedia, 
      type: 'Senate'
    }

  end
end

db[:items].insert(senators)

#Update senate keywords
senate_ids = []
db[:items].find({type: 'Senate'}).each do |senate|
  senate_ids << senate['_id']
end

senate = db[:keywords].find_one({friendly_name: 'Senate'})
senate[:item_ids] = senate_ids
db[:keywords].save(senate)



#Insert House records
houses = []
File.open("#{Rails.root}/db/house.txt", "r") do |infile|
  while (line = infile.gets)
    vals = line.split('::').collect { |val| val.strip }
    name = "#{vals[1]} #{vals[3]}"
    #title = vals[4]
    #party = vals[5]
    #district = vals[6]
    #gender = vals[7]
    #phone = vals[8]
    website = vals[9]
    wikipedia = vals[10]
    logo = vals[11]
    #display_order = vals[12]
    #branch = vals[13]
    #data1 = vals[14]
    #data2 = vals[15]
    state = vals[16]
    houses << {
      name: name, 
      logo: logo, 
      website: website, 
      wikipedia: wikipedia, 
      type: 'House'
    }
  end
end

db[:items].insert(houses)

#Update house keywords
house_ids = []
db[:items].find({type: 'House'}).each do |house|
  house_ids << house['_id']
end

house = db[:keywords].find_one({friendly_name: 'House'})
house[:item_ids] = house_ids
db[:keywords].save(house)


#Insert executive records
executives = []
File.open("#{Rails.root}/db/executive.txt", "r") do |infile|
  while (line = infile.gets)
    vals = line.split('::').collect { |val| val.strip }
    name = "#{vals[1]} #{vals[2]}"
    #title = vals[3]
    website = vals[4]
    wikipedia = vals[5]
    logo = vals[6]
    #display_order = vals[7]
    #branch = vals[8]
    #data1 = vals[9]
    #data2 = vals[10]
    executives << {
      name: name, 
      logo: logo, 
      website: website, 
      wikipedia: wikipedia, 
      type: 'Executive'
    }
  end
end

db[:items].insert(executives)

#Update executive keywords
executive_ids = []
db[:items].find({type: 'Executive'}).each do |executive|
  executive_ids << executive['_id']
end

executive = db[:keywords].find_one({friendly_name: 'Executive'})
executive[:item_ids] = executive_ids
db[:keywords].save(executive)


#Insert Fortune 500 companies

fortunes = []
File.open("#{Rails.root}/db/fortune_500.txt", "r") do |infile|
  while (line = infile.gets)
    vals = line.split('::').collect { |val| val.strip }
    name = vals[1]
    logo = vals[2]
    revenue = vals[3]
    profit = vals[4]
    website = vals[5]
    wikipedia = vals[6]
    fortunes << {
      name: name, 
      logo: logo, 
      website: website, 
      wikipedia: wikipedia, 
      type: 'Fortune500'
    }
  end
end

db[:items].insert(fortunes)

#Update fortune 500 keywords
fortune_ids = []
db[:items].find({type: 'Fortune500'}).each do |fortune|
  fortune_ids << fortune['_id']
end

fortune = db[:keywords].find_one({friendly_name: 'Fortune 500'})
fortune[:item_ids] = fortune_ids
db[:keywords].save(fortune)



#Insert Government Agencies
agencies = []

File.open("#{Rails.root}/db/agencies.txt", "r") do |infile|
  while (line = infile.gets)
    vals = line.split('::').collect { |val| val.strip }
    name = vals[1]
    website = vals[2]
    wikipedia = vals[3]
    logo = vals[4]
    agencies << {
      name: name, 
      logo: logo, 
      website: website, 
      wikipedia: wikipedia, 
      type: 'Agency'
    }
  end
end

db[:items].insert(agencies)

#Update agency keywords
agency_ids = []
db[:items].find({type: 'Agency'}).each do |agency|
  agency_ids << agency['_id']
end

agency = db[:keywords].find_one({friendly_name: 'Agency'})
agency[:item_ids] = agency_ids
db[:keywords].save(agency)



#Create zip data
db[:zips].remove({})
zips = []
File.open("#{Rails.root}/db/zips.txt", "r") do |infile|
  while (line = infile.gets)
    vals = line.split('::').collect { |val| val.strip }
    zip = vals[1]
    state = vals[2]
    latitude = vals[3]
    longitude = vals[4]
    zips << {
      zip: zip,
      state: state,
      latitude: latitude,
      longitude: longitude
    }
  end
end

db[:zips].insert(zips)


db[:users].remove({})
db[:user_votes].remove({})
db[:national_state_stats].remove({})
db[:national_year_stats].remove({})
db[:state_stats].remove({})

#Create test user
User.create(:email => 'test', :password => 'test', :zip => '28801', :state => 'NC', :birth_year => 1970)

users = []
(1..500).each do |i|
  random_zip = zips.sample
  email = Forgery(:internet).email_address
  password = Forgery(:basic).password
  birth_year = (1930..1990).to_a.sample

  users << {
    email: email,
    password: password,
    zip: random_zip[:zip],
    latitude: random_zip[:latitude],
    longitude: random_zip[:longitude],
    state: random_zip[:state],
    birth_year: birth_year
  }

  if(users.count > 50000)
    db[:users].insert(users)
    users = []
  end
end

db[:users].insert(users)
