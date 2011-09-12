class ItemsController < ApplicationController
  include Items::LoadItems
  def vote
    item_id = params[:item_id]
    user_id = current_user.id
    vote = params[:vote]
    #TODO: validate vote/item_id/check user_id (through authentication requirement)

    Vote.record_vote(current_user.id, item_id, vote)

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

    load_items(keyword)

    respond_to do |format|
      format.html { render :text => @items.to_json }
      format.json { render :json => @items.to_json }
    end
  end
end
