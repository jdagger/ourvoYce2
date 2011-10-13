class UtilitiesController < ApplicationController
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

      timings = Vote.record_vote(user[:id], user[:state], user[:zip], user[:birth_year], item_id, vote)
      if timings
        timings.keys.each do |key|
          total = total_times[key] || 0
          total = total + timings[key]
          total_times[key] = total
        end
      end
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
