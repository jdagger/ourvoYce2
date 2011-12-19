class UserVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :item

  attr_accessible :item_id, :user_id, :vote

  class << self
    def record_vote(user_id, item_id, vote)
      record = UserVote.where(:user_id => user_id, :item_id => item_id).first
      if record.nil?
        record = UserVote.new(:user_id => user_id, :item_id => item_id)
      end
      record.vote = vote
      record.save
    end
  end
end
