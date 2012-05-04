class Admin::SuggestTopicsController < Admin::ApplicationController

  def index
    page = params[:page] || 1
    sort_column = params[:c]
    sort_direction = params[:d] == "up" ? "asc" : "desc"

    @suggest_topics = SuggestTopic.paginate(:page => page, :per_page => 50)
    unless sort_column.blank?
      @suggest_topics = @suggest_topics.order("#{sort_column} #{sort_direction}")
    end
  end

  def destroy
    SuggestTopic.delete(params[:id])
    redirect_to admin_suggest_topics_url
  end

end
