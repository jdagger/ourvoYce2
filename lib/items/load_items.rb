module Items
  module LoadItems
    def load_items(keyword, filter, sort, user_id)

      @filter = filter
      @sort_name = ""
      @sort_direction = ""

      keyword_record = Keyword.where("path=?", keyword).first
      @keyword_friendly_name = keyword_record[:friendly_name]
      @keyword_path = keyword_record[:path]

      _item_ids = nil

      case filter.downcase
      when 'voted'
        _item_ids = Item.joins(:keyword_items => :keyword).joins(:user_votes).where('keywords.path' => keyword, 'user_votes.user_id' => user_id).select('items.id')
      when 'no-vote'
        voted_items = Item.joins(:keyword_items => :keyword).joins(:user_votes).where('keywords.path' => keyword, 'user_votes.user_id' => user_id).select('items.id')
        if voted_items.length > 0
          _item_ids = Item.joins(:keyword_items => :keyword).where('keywords.path' => keyword).where('items.id not in (?)', voted_items).select('items.id')
        else
          _item_ids = Item.joins(:keyword_items => :keyword).where('keywords.path' => keyword).select('items.id')
        end
      else
        @filter = 'all'
        _item_ids = Item.joins(:keyword_items => :keyword).where('keywords.path' => keyword).select('items.id')
      end

      unless sort.blank?
        sort_name, sort_direction = sort.downcase.split(':')

        unless sort_name.blank? || sort_direction.blank?
          sort_direction = sort_direction == 'asc' ? 'asc' : 'desc'

          @sort_name = sort_name
          @sort_direction = sort_direction

          case sort_name
          when 'name'
            _item_ids = _item_ids.order("name #{sort_direction}")
          when 'popularity'
            _item_ids = _item_ids.order("total_vote_count #{sort_direction}")
          else
            _item_ids = _item_ids.order("default_order #{sort_direction}")
            @sort_name = 'default_order'
            @sort_direction = sort_direction
          end
        end
      end

      #@item_ids = _item_ids.collect{|x| x[:_id] }
      @item_ids = _item_ids.map{ |x| x[:id] }


      #Load the first 10 records
      initial_items = @item_ids[0, 10]

      load_items_by_id(initial_items)
    end

    def load_items_by_id(item_ids)
      #Retrieve the items for the specified IDS
      item_arr = Item.get_by_ids(item_ids).to_a
      
      item_arr.each do |item|
        item[:related_keywords] = []
        item.keyword_items.each do |keyword_item|
          item[:related_keywords] << {friendly_name: keyword_item.keyword.friendly_name, path: keyword_item.keyword.path}
        end
      end

      #Place the item_arr in the original sort order
      sorted_arr = []
      item_ids.each do |item|
        sorted_arr << item_arr.select { |x| x[:id] == item.to_i}.first
      end

      if(!current_user.nil? && item_ids.count > 0)
        user_votes = UserVote.where(:user_id => current_user.id, :item_id => item_ids).to_a
      end

      #unless user_votes.nil? || user_votes.empty?
      unless user_votes.blank?
        sorted_arr.each do |item|
          idx = user_votes.find_index{ |x| x[:item_id].to_s == item.id.to_s }
          item[:user_vote] = user_votes[idx][:vote] unless idx.nil?
        end
      end

      @items = sorted_arr
    end
  end
end
