class Admin::ItemsController < Admin::ApplicationController

  def index
    page = params[:page] || 1
    @items = Item.includes(:tags).paginate(:page => page, :per_page => 50)
  end

  def show 
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new do |i|
      i.name = params[:item][:name]
      i.description = params[:item][:description]
      i.item_type = params[:item][:item_type]
      i.logo = params[:item][:logo]
      i.wikipedia = params[:item][:wikipedia]
      i.website = params[:item][:website]
      i.default_order = params[:item][:default_order]
    end
    if @item.save
      flash[:success] = 'Successfully created item'
      redirect_to edit_admin_item_path(@item)
    else
      flash[:error] = 'Failed ot create item'
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.name = params[:item][:name]
    @item.description = params[:item][:description]
    @item.item_type = params[:item][:item_type]
    @item.logo = params[:item][:logo]
    @item.wikipedia = params[:item][:wikipedia]
    @item.website = params[:item][:website]
    @item.default_order = params[:item][:default_order]

    if @item.save
      flash[:success] = 'Successfully updated item'
    else
      flash[:error] = 'Failed to save item'
    end
    render :edit
  end

  def destroy
    Item.delete(params[:id])
    flash[:success] = 'Successfully deleted item'
    redirect_to admin_items_path
  end

  def add_tag_by_autocomplete
    lookup_value = params['item-lookup']

    # lookup_value should have form: name (id)
    if lookup_value =~ /.*\((?<id>\d*?)\)$/
      tag_id = Regexp.last_match(:id)
      tag = Tag.find(tag_id)
      item = Item.find(params[:item_id])

      TagItem.create do |ti|
        ti.item = item
        ti.tag = tag
      end
      redirect_to edit_admin_item_path(item), :notice => 'Successfully added tag'
    else
      redirect_to request.referrer, :notice => 'Lookup not in valid format'
    end

  end

  def suggest_by_name
    results = Item.lookup_by_name(params[:name]).to_json
    render :json => results
  end

  def find_by_autocomplete
    lookup_value = params['item-lookup']

    # lookup_value should have form: name (id)
    if lookup_value =~ /.*\((?<id>\d*?)\)$/
      redirect_to admin_item_path(Regexp.last_match(:id))
    else
      redirect_to request.referrer, :notice => 'Lookup not in valid format'
    end
  end

end
