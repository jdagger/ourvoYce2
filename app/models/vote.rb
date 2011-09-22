class Vote
  include Mongoid::Document

  field :thumbs_up_count, type: Integer, default: 0
  field :thumbs_down_count, type: Integer, default: 0
  field :neutral_count, type: Integer, default: 0
  field :total_vote_count, type: Integer, default: 0

  embedded_in :national_state_stat
  embedded_in :national_year_stat
  embedded_in :birth_year_vote_count
  embedded_in :item



  def self.record_vote(user_id, state, zip, latitude, longitude, birth_year, item_id, vote)
    @timing = {}

    state = state.downcase

    start_time = Time.now

    item = nil

    record_time :item_lookup_time do
      return false if user_id.nil?
      return false unless [-1, 0, 1].include?(vote)

      item = Item.find(item_id) rescue nil
      return false if item.nil?
    end

    new_vote = false
    previous_vote = -2

    record_time :user_vote_time do
      #Update the user_vote table
      user_vote = UserVote.find_or_initialize_by({user_id: user_id, item_id: item_id})
      previous_vote = user_vote.vote
      new_vote = user_vote.new_record?

      return false if previous_vote == vote

      #Store the vote to the UserVote table
      user_vote.vote = vote
      user_vote.vote_date = Time.now
      user_vote.save!
    end


    #Update counts in Item table
    record_time :update_item_votes_time do
      Vote.update_votes(Item, item, new_vote, vote, previous_vote)
    end
    


    #Increment national votes
    record_time :update_national_year_time do
      national_year_stat = NationalYearStat.find_or_create_by({:item_id => item_id, :birth_year => birth_year})
      Vote.update_votes(NationalYearStat, national_year_stat, new_vote, vote, previous_vote)
    end


    record_time :update_national_state_time do
      national_state_stat = NationalStateStat.find_or_create_by({:item_id => item_id, :state => state})
      Vote.update_votes(NationalStateStat, national_state_stat, new_vote, vote, previous_vote)
    end

    record_time :update_state_stats do
      state_stat = StateStat.find_or_create_by({:state => state, :item_id => item_id})
      update_votes(StateStat, state_stat, new_vote, vote, previous_vote, "#{birth_year}.")
    end


    @timing[:total_time] = Time.now - start_time
      
    return @timing
  end

  def self.record_time(name, &block)
    start = Time.now
    yield
    @timing[name] = Time.now - start 
  end

  def self.build_increment_logic(new_vote, current_vote, previous_vote, prefix)
    vote_changes = {}

    if new_vote
      vote_changes["#{prefix}vote.total_vote_count"] = 1
    else
      if(previous_vote == 1)
        vote_changes["#{prefix}vote.thumbs_up_count"] = -1
      elsif(previous_vote == 0)
        vote_changes["#{prefix}vote.neutral_count"] = -1
      else
        vote_changes["#{prefix}vote.thumbs_down_count"] = -1
      end
    end

    if(current_vote == 1)
      vote_changes["#{prefix}vote.thumbs_up_count"] = 1
    elsif(current_vote == 0)
      vote_changes["#{prefix}vote.neutral_count"] = 1
    else
      vote_changes["#{prefix}vote.thumbs_down_count"] = 1
    end

    return vote_changes
  end

  def self.update_votes(model, entity, new_vote, current_vote, previous_vote, prefix="")
    vote_changes = self.build_increment_logic(new_vote, current_vote, previous_vote, prefix)
    model.collection.update({'_id' => entity.id}, {'$inc' => vote_changes})
  end
end
