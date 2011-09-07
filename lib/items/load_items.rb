module Items
  module LoadItems
    def load_items(keyword)
      keyword = Keyword.keyword_by_path(keyword)
      @keyword_friendly_name = keyword[:friendly_name]
      @items = Item.get_by_ids(keyword[:item_ids]).take(10)
    end
  end
end
