class UserVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :item

  class << self
    def record_vote(user_id, item_id, vote)
      record = UserVote.where(:user_id => user_id, :item_id => item_id).first
      record = UserVote.new(:user_id => user_id, :item_id => item_id) if record.nil?
      record.vote = vote
      record.save
    end
  end
end
