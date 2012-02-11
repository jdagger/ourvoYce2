class Admin::TagsController < Admin::ApplicationController
  def index
    page = params[:page] || 1
    sort_column = params[:c]
    sort_direction = params[:d] == "up" ? "asc" : "desc"

    @tags = Tag.includes(:items).paginate(:page => page, :per_page => 50)

    unless sort_column.blank?
      @tags = @tags.order("#{sort_column} #{sort_direction}")
    end
  end

  def show 
    @tag = Tag.find(params[:id])
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new do |t|
      t.friendly_name = params[:tag][:friendly_name]
      t.path = params[:tag][:path]
      t.hot_topic = params[:tag][:hot_topic]
      t.popular = params[:tag][:popular]
    end

    if @tag.save
      flash[:success] = 'Successfully created tag'
      redirect_to edit_admin_tag_path(@tag)
    else
      flash[:error] = "Failed to create tag"
      render :new
    end

  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    @tag.friendly_name = params[:tag][:friendly_name]
    @tag.path = params[:tag][:path]
    @tag.hot_topic = params[:tag][:hot_topic]
    @tag.popular = params[:tag][:popular]
    if @tag.save
      flash[:success] = 'Successfully updated tag'
    else
      flash[:error] = 'Failed to save tag'
    end

    render :edit
  end

  def destroy
    Tag.delete(params[:id])
    flash[:success] = 'Successfully deleted tag'
    redirect_to admin_tags_path
  end

  def add_item_by_autocomplete
    lookup_value = params['item-lookup']

    # lookup_value should have form: name (id)
    if lookup_value =~ /.*\((?<id>\d*?)\)$/
      item_id = Regexp.last_match(:id)
      item = Item.find(item_id)
      tag = Tag.find(params[:tag_id])

      TagItem.create do |ti|
        ti.item = item
        ti.tag = tag
      end
      redirect_to request.referrer, :notice => 'Successfully added item'
    else
      redirect_to request.referrer, :notice => 'Lookup not in valid format'
    end

  end


  def suggest_by_name
    results = Tag.lookup_by_name(params[:name]).to_json
    render :json => results
  end

  def find_by_autocomplete
    lookup_value = params['item-lookup']

    # lookup_value should have form: name (id)
    if lookup_value =~ /.*\((?<id>\d*?)\)$/
      redirect_to admin_tag_path(Regexp.last_match(:id))
    else
      redirect_to request.referrer, :notice => 'Lookup not in valid format'
    end
  end
end
