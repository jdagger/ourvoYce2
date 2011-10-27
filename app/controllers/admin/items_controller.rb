class Admin::ItemsController < Admin::ApplicationController
  def index
    page = params[:page] || 1
    @items = Item.paginate(:page => page)
  end

  def show 
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.create(params[:item])
    flash[:success] = 'Successfully created item'
    render :edit
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update_attributes(params[:item])
    flash[:success] = 'Successfully updated item'
    render :edit
  end

  def destroy
    Item.delete(params[:id])
    flash[:success] = 'Successfully deleted item'
    redirect_to admin_items_path
  end
end
