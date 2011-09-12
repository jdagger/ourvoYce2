class Vote
  def self.record_vote(user_id, item_id, vote)
    #Rails.logger.error("###############################")

    #Rails.logger.error "1"
    return false if user_id.nil?

    #Rails.logger.error "2"
    return false unless [-1, 0, 1].include?(vote)

    #Rails.logger.error "3"
    item = Item.find(item_id) rescue nil
    return false if item.nil?

    #Rails.logger.error "4"

    #Update the user_vote table
    user_vote = UserVote.find_or_initialize_by({user_id: user_id, item_id: item_id})

    previous_vote = user_vote.vote
    new_vote = user_vote.new_record?

    #Rails.logger.error "5"

    return false if previous_vote == vote

    #Rails.logger.error "6"

    #Store the vote to the UserVote table
    user_vote.vote = vote
    #Rails.logger.error "NEW RECORD: #{user_vote.new_record?}"
    user_vote.vote_date = Time.now
    user_vote.save!

    #Rails.logger.error "7"
    #Update counts in Item table

    #First, undo previous vote, unless this is first time vote for item
    unless new_vote
      if(previous_vote == 1)
        item.inc(:thumbs_up_count, -1)
      elsif(previous_vote == 0)
        item.inc(:neutral_count, -1)
      else
        item.inc(:thumbs_down_count, -1)
      end
    end

    if new_vote
      item.inc(:total_vote_count, 1)
    end

    #Then, increment current votes.
    #TODO: Combine decrement previous/increment current into a single call
    if(vote == 1)
      item.inc(:thumbs_up_count, 1)
    elsif(vote == 0)
      item.inc(:neutral_count, 1)
    else
      item.inc(:thumbs_down_count, 1)
    end
      
    #Rails.logger.error "8"

    #Rails.logger.error "9"
    #Rails.logger.error "10"
    #Rails.logger.error "11"
    #Rails.logger.error "12"
    #Rails.logger.error "13"
    #Rails.logger.error "14"
    #Rails.logger.error "15"
    #Rails.logger.error "16"
    #Rails.logger.error "17"


    #Rails.logger.error("###############################")
  end

end
