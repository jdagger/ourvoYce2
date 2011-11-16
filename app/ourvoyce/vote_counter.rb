  module VoteCounter
    def update_vote_counts(previous_vote, new_vote)
      case previous_vote
      when 1
        self.thumbs_up_vote_count -= 1
      when 0
        self.neutral_vote_count -= 1
      when -1
        self.thumbs_down_vote_count -= 1
      end

      case new_vote
      when 1
        self.thumbs_up_vote_count += 1
      when 0
        self.neutral_vote_count += 1
      when -1
        self.thumbs_down_vote_count += 1
      end

      if previous_vote.nil?
        self.total_vote_count += 1
      end
    end
  end
