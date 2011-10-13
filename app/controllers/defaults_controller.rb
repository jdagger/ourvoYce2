class DefaultsController < ApplicationController
  include Items::LoadItems

  def index
    @keywords = Keyword.all
  end

  def keyword
    keyword_path = params[:keyword_path]
    filter = params[:filter]
    sort = params[:sort]

    load_items(keyword_path, filter, sort, current_user.id)

    @total_users = User.count
    @keywords = Keyword.keyword_list

    @user_vote_count = UserVote.where(user_id: current_user.id).count
  end

end
