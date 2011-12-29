class ItemsController < ApplicationController
  include Items::LoadItems

  def default
    load_default_item_data if request.format.html?
  end

  #Vote sent from user
  def vote
    unless current_user.nil?
      item_id = params[:item_id]
      user_id = current_user.id
      vote = params[:new_vote]
      #TODO: validate vote/item_id/check user_id (through authentication requirement)
      Vote.record_vote(current_user.id, current_user.state, current_user.zip, current_user.birth_year, item_id, vote)
    end

    respond_to do |format|
      format.json { render :json => {success: 0, message: 'Not authenticate'}.to_json }
    end
  end


  #Toggle favorite setting for record
  def toggle_favorite
    is_favorite = false

    favorite = Favorite.where(:item_id => params[:item_id], :user_id => current_user.id).first

    if favorite.nil?
      favorite = Favorite.new
      favorite.item_id = params[:item_id]
      favorite.user_id = current_user.id
      favorite.save
      is_favorite = true
    else
      favorite.delete
      is_favorite = false
    end
    respond_to do |format|
      format.json { render :json => {favorite: is_favorite}.to_json }
    end
  end

  #Given a list of item_ids, retrieve items
  def fetch
    #TODO: Cap item_ids to some max length (10?)
    #max_additional_records = OURVOYCE_CONFIG['additional_items_to_load']
    item_ids = params[:item_ids]

    load_items_by_id(item_ids, current_user)

    respond_to do |format|
      format.json { render :json => {:item_ids => @item_ids, :items => @items}.to_json}
    end

  end

  #Load data for the specified tag
  def tag
    tag = params[:tag]
    filter = params[:filter] || 'all'
    sort = params[:sort] || 'default:asc'

    if request.format.html?
      redirect_to "/ov/#!/tag/#{tag}/#{filter}/#{sort}"
      return
    end


    load_tag_items(tag, filter, sort, current_user)


    @base_url = "tag"

    #render :json => {:item_ids => @item_ids, :items => @items, :tag_friendly_name => @tag_friendly_name, :tag_path => @tag_path, :filter => @filter, :sort_name => @sort_name, :sort_direction => @sort_direction, :authenticated => !current_user.nil?, :records_to_fetch => OURVOYCE_CONFIG['additional_items_to_load']}.to_json
    render :json => load_common_item_request_data.to_json
  end

  #Retrieve the favorites
  def favorites
    filter = params[:filter] || 'all'
    sort = params[:sort] || 'default:asc'

    if request.format.html?
      redirect_to "/ov/#!/favorites/#{filter}/#{sort}"
      return
    end

    load_favorite_items(filter, sort, current_user)

    @base_url = "favorites"
    @tag_friendly_name = 'Favorites'
    @tag_path = ''

    #render :json => {:item_ids => @item_ids, :items => @items, :base_url => @base_url, :tag_friendly_name => 'Favorites', :tag_path => '', :filter => @filter, :sort_name => @sort_name, :sort_direction => @sort_direction, :authenticated => !current_user.nil?, :records_to_fetch => OURVOYCE_CONFIG['additional_items_to_load']}.to_json
    render :json => load_common_item_request_data.to_json

  end

  #Retrieve single item
  def fetch_item
    filter = 'all'
    sort = 'default:asc'
    id = params[:id]

    if request.format.html?
      redirect_to "/ov/#!/item/#{id}"
      return
    end

    load_item(id, current_user)

    @base_url = "item"
    @tag_friendly_name = 'Item'
    @tag_path = ''

    render :json => load_common_item_request_data.to_json

    #render :json => {:item_ids => @item_ids, :items => @items, :base_url => @base_url, :tag_friendly_name => 'Hot Topics', :tag_path => '', :filter => @filter, :sort_name => @sort_name, :sort_direction => @sort_direction, :authenticated => !current_user.nil?}.to_json
  end

  #Retrieve hot topics
  def hot_topics
    filter = params[:filter] || 'all'
    sort = params[:sort] || 'default:asc'

    if request.format.html?
      redirect_to "/ov/#!/hot_topics/#{filter}/#{sort}"
      return
    end

    load_hot_topic_items(filter, sort, current_user)

    @base_url = "hot_topics"
    @tag_friendly_name = 'Hot Topics'
    @tag_path = ''

    render :json => load_common_item_request_data.to_json

    #render :json => {:item_ids => @item_ids, :items => @items, :base_url => @base_url, :tag_friendly_name => 'Hot Topics', :tag_path => '', :filter => @filter, :sort_name => @sort_name, :sort_direction => @sort_direction, :authenticated => !current_user.nil?}.to_json
  end

  def load_common_item_request_data
    #TODO: Refactor in view to remove order dependence. Use symbol names instead of ordered parameters
    args = {}
    args[:item_ids] = @item_ids
    args[:items] = @items
    args[:base_url] = @base_url
    args[:tag_friendly_name] = @tag_friendly_name
    args[:tag_path] = @tag_path
    args[:filter] = @filter
    args[:sort_name] = @sort_name
    args[:sort_direction] = @sort_direction
    args[:authenticated] = !current_user.nil?
    return args
  end

  #Load the default data needed to render the page.  Required for full page loads
  def load_default_item_data
    @total_users = User.count
    @popular_tags = Tag.popular_tags
    @hot_topic_tags = Tag.hot_topics
    @authenticated = !current_user.nil?
    if current_user.nil?
      @favorites_count = 0
      @user_vote_count = 0
    else
      @member_since = current_user.confirmed_at
      @favorites_count = Favorite.where(user_id: current_user.id).count
      @user_vote_count = UserVote.where(user_id: current_user.id).count
    end
    @records_to_fetch = OURVOYCE_CONFIG['additional_items_to_load']
  end

  #Load details for specified item
  def details
    item = Item.find(params[:item_id])
    respond_to do |format|
      format.json { render :json => item.to_json }
    end
  end

end
