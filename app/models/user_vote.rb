class UserVote
  include Mongoid::Document

  field :user_id, type: String
  field :item_id, type: String
  field :vote, type: Integer
  field :vote_date, type: DateTime

  def self.update_vote(item_id, user_id, vote)
    #TODO: validate vote/item_id/check user_id (through authentication requirement)
    user_vote = find_or_initialize_by({user_id: user_id, item_id: item_id})
    user_vote.vote = vote
    user_vote.vote_date = Time.now
    return user_vote.save!
  end

end
