class UtilitiesController < ApplicationController
  def generate_random_votes

    votes_to_insert = 1000

    start_time = Time.now

    #users = User.only(:id).to_a
    users = User.all.to_a
    items = Item.only(:id).to_a

    setup_time = Time.now

    (1..votes_to_insert).each do |i|
      user = users.sample
      item_id = items.sample[:_id]
      vote = [-1, 0, 1].sample
      Vote.record_vote(user[:_id], user[:state], user[:zip], user[:latitude], user[:longitude], user[:birth_year], item_id, vote)
    end

    insert_time = Time.now

    total_user_votes = UserVote.count

    render :json => {success: 1, votes_recorded: votes_to_insert, setup_time: "#{setup_time - start_time}", vote_time: "#{insert_time - setup_time}", total_user_votes: total_user_votes}.to_json
  end
end
