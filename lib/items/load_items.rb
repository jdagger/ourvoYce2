module Items
  module LoadItems
    def load_items(keyword, filter, sort)

      keyword_record = Keyword.find(keyword)
      @keyword_friendly_name = keyword_record[:friendly_name]
      @keyword_path = keyword_record[:_id]

      _item_ids = nil

      case filter.downcase
      when 'voted'
        _item_ids = Item.any_in('related_tags.path' => [keyword]).only(:_id).order_by(:name, :asc)
      else
        _item_ids = Item.any_in('related_tags.path' => [keyword]).only(:_id).order_by(:name, :asc)
      end

      @item_ids = _item_ids.collect{|x| x[:_id] }

      #Load the first 10 records
      initial_items = @item_ids[0, 10]

      load_items_by_id(initial_items)
    end

    def load_items_by_id(item_ids)
      #Retrieve the items for the specified IDS
      item_arr = Item.get_by_ids(item_ids).to_a

      #Place the item_arr in the original sort order
      sorted_arr = []
      item_ids.each do |id|
        sorted_arr << item_arr.select { |x| x[:_id].to_s == id.to_s }.first
      end

      if(!current_user.nil? && item_ids.count > 0)
        user_votes = UserVote.where(:user_id => current_user.id, :item_id.in => item_ids).to_a
      end

      unless user_votes.nil? || user_votes.empty?
        sorted_arr.each do |item|
          idx = user_votes.find_index{ |x| x[:item_id].to_s == item.id.to_s }
          item[:user_vote] = user_votes[idx][:vote] unless idx.nil?
        end
      end

      @items = sorted_arr
    end
  end
end
