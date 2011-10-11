class DefaultsController < ApplicationController
  include Items::LoadItems

  def index
    @keywords = Keyword.all
  end

  def keyword
    keyword_path = params[:keyword_path]
    filter = params[:filter]
    sort = params[:sort]

    load_items(keyword_path, filter, sort)

    @total_users = User.count
    @keywords = Keyword.keyword_list
  end

end
