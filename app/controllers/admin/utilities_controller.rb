class Admin::UtilitiesController < Admin::ApplicationController
  include ActionView::Helpers::NumberHelper

  def index
  end

  def create_seed_file
    header_info = "//Created: #{Time.now.to_s}\n"
    output = header_info << create_tag_seed_data << create_item_seed_data
    send_data output, {filename: 'tag_item_seed_data.txt', type: 'text/plain', disposition: 'attachment' }
  end


  def create_tag_seed_data(delimiter = '::')
    tag_data = "##TAGS##\n"
    tag_data << "//id, path, friendly_name, popular, hot_topic\n"
    Tag.order('id asc').each do |tag|
      fields = [tag.id, tag.path, tag.friendly_name, tag.popular, tag.hot_topic]
      tag_data << "#{delimiter}#{fields.join(delimiter)}#{delimiter}\n"
    end

    tag_data
  end


  def create_item_seed_data(delimiter = '::')
    item_data = "##ITEMS##\n"
    item_data << "//id, name, description, item_type, logo, website, wikipedia, default_order, tags\n"

    Item.includes(:tags).order('id asc').each do |item|
      fields = [item.id, item.name, item.description, item.item_type, item.logo, item.website, item.wikipedia, item.default_order, item.tags.pluck('tags.id').join(',')]
      item_data << "#{delimiter}#{fields.join(delimiter)}#{delimiter}\n"
    end

    item_data
  end

  def generate_random_votes
    votes_to_insert = params[:count].to_i

    start_time = Time.now

    #users = User.only(:id).to_a
    users = User.all.to_a
    #items = Item.only(:id).to_a
    items = Item.select(:id).to_a

    setup_time = Time.now

    total_sample_time = 0
    total_times = {}

    (1..votes_to_insert).each do |i|
      sample_start = Time.now
      user = users.sample
      item_id = items.sample[:id]
      vote = [-1, -1, -1, 0, 0, 1, 1, 1, 1, 1, 1].sample
      total_sample_time = total_sample_time + (Time.now - sample_start)

      Vote.record_vote(user[:id], user[:state], user[:zip], user[:birth_year], item_id, vote)
      #timings = Vote.record_vote(user[:id], user[:state], user[:zip], user[:birth_year], item_id, vote)
      #if timings
        #timings.keys.each do |key|
          #total = total_times[key] || 0
          #total = total + timings[key]
          #total_times[key] = total
        #end
      #end
    end

    insert_time = Time.now

    total_user_votes = UserVote.count

    render :xml => {
      success: 1, 
      votes_recorded: votes_to_insert, 
      setup_time: "#{setup_time - start_time}", 
      sample_time: "#{total_sample_time}",  
      vote_time: "#{insert_time - setup_time}", 
      total_time: total_times,
      total_user_votes: total_user_votes
    }.to_xml
  end
end
