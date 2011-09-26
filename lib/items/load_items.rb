module Items
  module LoadItems
    def load_items(keyword)
      keyword = Keyword.keyword_by_path(keyword)
      @keyword_friendly_name = keyword[:friendly_name]

      @item_ids = keyword[:item_ids].to_a

      #Load the first 10 records
      initial_items = @item_ids[0,10]

      load_items_by_id(initial_items)

    end

    def load_items_by_id(item_ids)
      #Retrieve the items for the specified IDS
      item_arr = Item.get_by_ids(item_ids).to_a


      if(!current_user.nil? && item_ids.count > 0)
        user_votes = UserVote.where(:user_id => current_user.id, :item_id.in => item_ids).to_a
      end

      unless user_votes.nil? || user_votes.empty?
        item_arr.each do |item|
          idx = user_votes.find_index{ |x| x[:item_id].to_s == item.id.to_s }
          item[:user_vote] = user_votes[idx][:vote] unless idx.nil?
        end
      end

      @items = item_arr

    end
  end
end
