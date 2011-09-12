class DefaultsController < ApplicationController
  include Items::LoadItems

  def index
    @keywords = Keyword.all
  end

  def keyword
    keyword_path = params[:keyword_path]

    load_items(keyword_path)

    @total_users = User.count
    @keywords = Keyword.keyword_list
  end

end
