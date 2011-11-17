class DefaultsController < ApplicationController
  def index

    redirect_to hot_topics_path unless current_user.nil?

    @hot_topics = Tag.where(hot_topic: true).limit(24)
  end

end
