class DefaultsController < ApplicationController
  def index
    @keywords = Keyword.all
  end

  def keyword
    keyword_path = params[:keyword_path]

    item_ids = Keyword.items_by_path(keyword_path)[:item_ids]

    @items = Item.get_by_ids(item_ids)
    @keywords = Keyword.keyword_list
  end

end
