class UtilitiesController < ApplicationController
  def generate_random_votes

    votes_to_insert = 500

    start_time = Time.now

    #users = User.only(:id).to_a
    users = User.all.to_a
    items = Item.only(:id).to_a

    setup_time = Time.now

    total_sample_time = 0

    total_db_time = 0
    item_lookup_time = 0
    user_vote_time = 0
    update_item_votes_time = 0
    update_national_year_time = 0
    update_national_state_time = 0
    (1..votes_to_insert).each do |i|
      sample_start = Time.now
      user = users.sample
      item_id = items.sample[:_id]
      vote = [-1, 0, 1].sample
      total_sample_time = total_sample_time + (Time.now - sample_start)

      timings = Vote.record_vote(user[:_id], user[:state], user[:zip], user[:latitude], user[:longitude], user[:birth_year], item_id, vote)
      if timings
        total_db_time = total_db_time + timings[:total_time]
        item_lookup_time = item_lookup_time + timings[:item_lookup_time]
        user_vote_time = user_vote_time + timings[:user_vote_time]
        update_item_votes_time = update_item_votes_time + timings[:update_item_votes_time]
        update_national_year_time = update_national_year_time + timings[:update_national_year_time]
        update_national_state_time = update_national_state_time + timings[:update_national_state_time]
      end
    end

    insert_time = Time.now

    total_user_votes = UserVote.count

    render :json => {
      success: 1, 
      votes_recorded: votes_to_insert, 
      setup_time: "#{setup_time - start_time}", 
      sample_time: "#{total_sample_time}",  
      total_db_time: total_db_time,
      item_lookup_time: item_lookup_time , 
      user_vote_time: user_vote_time , 
      update_item_votes_time: update_item_votes_time , 
      update_national_year_time: update_national_year_time , 
      update_national_state_time: update_national_state_time , 
      vote_time: "#{insert_time - setup_time}", 
      total_user_votes: total_user_votes
    }.to_json
  end
end
