class Stat < ActiveRecord::Base
  include VoteCounter

  class << self
    def find_row(item_id, birth_year, zip)
      where(:item_id => item_id, :zip => zip, :birth_year => birth_year).first
    end



    def record_vote(item_id, birth_year, state, zip, previous_vote, new_vote)
      #Validate inputs
      return nil unless [nil, -1, 0, 1].include? previous_vote
      return nil unless [-1, 0, 1].include? new_vote

      #Check item exists
      return nil if Item.where(:id => item_id).count != 1

      return true if previous_vote == new_vote


      stat = find_row(item_id, birth_year, zip)

      if stat.nil?
        stat = Stat.new
        stat.item_id = item_id
        stat.zip = zip
        stat.birth_year = birth_year
        stat.state = state.downcase
      end

      stat.update_vote_counts(previous_vote, new_vote)

      stat.save
    end
  end
end
