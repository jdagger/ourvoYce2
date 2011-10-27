class Admin::TagsController < Admin::ApplicationController
  def index
    page = params[:page] || 1
    @tags = Tag.paginate(:page => page)
  end

  def show 
    @tag = Tag.find(params[:id])
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.create(params[:tag])
    flash[:success] = 'Successfully created tag'
    render :edit
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    @tag.update_attributes(params[:tag])
    flash[:success] = 'Successfully updated tag'
    render :edit
  end

  def destroy
    Tag.delete(params[:id])
    flash[:success] = 'Successfully deleted tag'
    redirect_to admin_tags_path
  end
end
