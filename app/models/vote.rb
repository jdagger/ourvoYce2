class Vote
  include Mongoid::Document

  field :thumbs_up_count, type: Integer, default: 0
  field :thumbs_down_count, type: Integer, default: 0
  field :neutral_count, type: Integer, default: 0
  field :total_vote_count, type: Integer, default: 0

  embedded_in :national_state_stat
  embedded_in :national_year_stat
  embedded_in :item

  def self.record_vote(user_id, state, zip, latitude, longitude, birth_year, item_id, vote)
    return false if user_id.nil?
    return false unless [-1, 0, 1].include?(vote)

    item_id = item_id.to_s unless item_id.kind_of? String

    @timing = {}

    state = state.downcase

    start_time = Time.now

    item = nil

    new_vote = false
    previous_vote = -2

    user_vote = nil

    record_time :user_vote_lookup_time do
      user_vote = UserVote.find_or_create_by({item_id: item_id, user_id: user_id})
    end

    record_time :user_vote_update_time do
      previous_vote = user_vote.vote
      #new_vote = user_vote.new_record?
      new_vote = user_vote.vote.nil?
      return false if previous_vote == vote

      #Store the vote to the UserVote table
      user_vote.vote = vote
      user_vote.vote_date = Time.now
      user_vote.save!
    end


    #Update counts in Item table
    record_time :update_item_votes_time do
      vote_changes = build_increment_logic(new_vote, vote, previous_vote)
      Item.collection.update({'_id' => BSON::ObjectId.convert(Item, item_id)}, {'$inc' => vote_changes})
    end
    

    #Increment national votes
    record_time :update_national_year_time do
      id = "#{item_id} #{birth_year}"
      vote_changes = self.build_increment_logic(new_vote, vote, previous_vote)
      NationalYearStat.collection.update({"_id" => id, :birth_year => birth_year, :item_id => item_id}, {'$inc' => vote_changes}, {:upsert => true})
    end

    record_time :update_national_state_time do
      id = "#{item_id} #{state}"
      vote_changes = self.build_increment_logic(new_vote, vote, previous_vote)
      NationalStateStat.collection.update({"_id" => id, :state => state, :item_id => item_id}, {'$inc' => vote_changes}, {:upsert => true})
    end

    record_time :update_state_year_stats do
      id = "#{item_id} #{state}"
      vote_changes = self.build_increment_logic(new_vote, vote, previous_vote, "#{birth_year}.")
      StateYearStat.collection.update({"_id" => id, :state => state, :item_id => item_id}, {'$inc' => vote_changes}, {:upsert => true})
    end

    record_time :update_state_zip_stats do
      id = "#{item_id} #{state}"
      vote_changes = self.build_increment_logic(new_vote, vote, previous_vote, "zips.#{zip}.")
      StateZipStat.collection.update({"_id" => id, :state => state, :item_id => item_id}, {'$inc' => vote_changes, '$set' => {"zips.#{zip}.latitude" => latitude, "zips.#{zip}.longitude" => longitude}}, {:upsert => true})
    end

    @timing[:total_time] = Time.now - start_time
      
    return @timing
  end

  def self.record_time(name, &block)
    start = Time.now
    yield
    @timing[name] = Time.now - start 
  end

  def self.build_increment_logic(new_vote, current_vote, previous_vote, prefix = "")
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
end
