module Items
  module LoadItems

    def load_hot_topic_items(filter, sort, current_user)

      @filter = filter
      @sort_name = ""
      @sort_direction = ""

      @tag_friendly_name = 'Hot Topics'
      @tag_path = ''

      _item_ids = nil

      default_search = Item.joins(:tag_items => :tag).where('tags.hot_topic' => true).select('items.id')

      if current_user.nil?
        _item_ids = default_search
      else
        case filter.downcase
        when 'voted'
          _item_ids = Item.joins(:tag_items => :tag).joins(:user_votes).where('tags.hot_topic' => true, 'user_votes.user_id' => current_user.id).select('items.id')
        when 'no-vote'
          voted_items = Item.joins(:tag_items => :tag).joins(:user_votes).where('tags.hot_topic' => true, 'user_votes.user_id' => current_user.id).select('items.id')
          if voted_items.length > 0
            _item_ids = Item.joins(:tag_items => :tag).where('tags.hot_topic' => true).where('items.id not in (?)', voted_items).select('items.id')
          else
            _item_ids = Item.joins(:tag_items => :tag).where('tags.hot_topic' => true).select('items.id')
          end
        else
          @filter = 'all'
          _item_ids = default_search
        end
      end

      unless sort.blank?
        sort_name, sort_direction = sort.downcase.split(':')

        unless sort_name.blank? || sort_direction.blank?
          sort_direction = sort_direction == 'desc' ? 'desc' : 'asc'

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


    def load_favorite_items(filter, sort, current_user)

      return nil if current_user.nil?



      @filter = filter
      @sort_name = ""
      @sort_direction = ""

      @tag_friendly_name = 'Favorites'
      @tag_path = ''

      _item_ids = nil

      case filter.downcase
      when 'voted'
        _item_ids = Item.joins(:favorites).joins(:user_votes).where('favorites.user_id' => current_user.id, 'user_votes.user_id' => current_user.id).select('items.id')
      when 'no-vote'
        voted_items = Item.joins(:favorites).joins(:user_votes).where('favorites.user_id' => current_user.id, 'user_votes.user_id' => current_user.id).select('items.id')
        if voted_items.length > 0
          _item_ids = Item.joins(:favorites).where('favorites.user_id' => current_user.id).where('items.id not in (?)', voted_items).select('items.id')
        else
          _item_ids = Item.joins(:favorites).where('favorites.user_id' => current_user.id).select('items.id')
        end
      else
        @filter = 'all'
        _item_ids = Item.joins(:favorites).where('favorites.user_id' => current_user.id).select('items.id')
      end

      unless sort.blank?
        sort_name, sort_direction = sort.downcase.split(':')

        unless sort_name.blank? || sort_direction.blank?
          sort_direction = sort_direction == 'desc' ? 'desc' : 'asc'

          @sort_name = sort_name
          @sort_direction = sort_direction

          case sort_name
          when 'name'
            _item_ids = _item_ids.order("name #{sort_direction}")
          when 'popularity'
            _item_ids = _item_ids.order("total_vote_count #{sort_direction}")
          else
            _item_ids = _item_ids.order("favorites.updated_at #{sort_direction}")
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

    def load_tag_items(tag, filter, sort, user_id)

      @filter = filter
      @sort_name = ""
      @sort_direction = ""

      tag_record = Tag.where("path=?", tag).first
      @tag_friendly_name = tag_record[:friendly_name]
      @tag_path = tag_record[:path]

      _item_ids = nil

      case filter.downcase
      when 'voted'
        _item_ids = Item.joins(:tag_items => :tag).joins(:user_votes).where('tags.path' => tag, 'user_votes.user_id' => user_id).select('items.id')
      when 'no-vote'
        voted_items = Item.joins(:tag_items => :tag).joins(:user_votes).where('tags.path' => tag, 'user_votes.user_id' => user_id).select('items.id')
        if voted_items.length > 0
          _item_ids = Item.joins(:tag_items => :tag).where('tags.path' => tag).where('items.id not in (?)', voted_items).select('items.id')
        else
          _item_ids = Item.joins(:tag_items => :tag).where('tags.path' => tag).select('items.id')
        end
      else
        @filter = 'all'
        _item_ids = Item.joins(:tag_items => :tag).where('tags.path' => tag).select('items.id')
      end

      unless sort.blank?
        sort_name, sort_direction = sort.downcase.split(':')

        unless sort_name.blank? || sort_direction.blank?
          sort_direction = sort_direction == 'desc' ? 'desc' : 'asc'

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
        item[:related_tags] = []
        item.tag_items.each do |tag_item|
          item[:related_tags] << {friendly_name: tag_item.tag.friendly_name, path: tag_item.tag.path}
        end
      end

      #Place the item_arr in the original sort order
      sorted_arr = []
      item_ids.each do |item|
        sorted_arr << item_arr.select { |x| x[:id] == item.to_i}.first
      end

      favorites = nil

      if(!current_user.nil? && item_ids.count > 0)
        user_votes = UserVote.where(:user_id => current_user.id, :item_id => item_ids).to_a
        favorites = Favorite.where(:user_id => current_user.id, :item_id => item_ids).to_a
      end

      #unless user_votes.nil? || user_votes.empty?
      unless user_votes.blank?
        sorted_arr.each do |item|
          idx = user_votes.find_index{ |x| x[:item_id].to_s == item.id.to_s }
          item[:user_vote] = user_votes[idx][:vote] unless idx.nil?
        end
      end

      unless favorites.nil? || favorites.count == 0
        sorted_arr.each do |item|
          idx = favorites.find_index{ |x| x[:item_id].to_s == item.id.to_s }
          if idx.blank? 
            item[:favorite] = false
          else
            item[:favorite] = true
          end
        end
      end

      @items = sorted_arr
    end
  end
end
