class Vote

  def self.record_vote(user_id, state, zip, birth_year, item_id, new_vote)
    user_vote = UserVote.where(:user_id => user_id, :item_id => item_id).first
    previous_vote = nil
    previous_vote = user_vote.vote unless user_vote.nil?

    UserVote.record_vote(user_id, item_id, new_vote)



    Item.record_vote(item_id, previous_vote, new_vote)
    Stat.record_vote(item_id, birth_year, state, zip, previous_vote, new_vote)
  end
end
