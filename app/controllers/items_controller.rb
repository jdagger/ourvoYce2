class ItemsController < ApplicationController
  def vote
    respond_to do |format|
      format.json { render :json => {success: 1}.to_json }
    end
  end

  def details
    item = Item.find(params[:item_id])
    respond_to do |format|
      format.json { render :json => item.to_json }
    end
  end

  def keyword
    keyword = params[:keyword]
    item_ids = Keyword.items_by_path(keyword).item_ids
    @items = Item.get_by_ids(item_ids)

    respond_to do |format|
      format.html { render :text => @items.to_json }
      format.json { render :json => @items.to_json }
    end
  end
end
