class DefaultsController < ApplicationController
  def index
    @hot_topics = Tag.where(hot_topic: true).limit(24)
  end

end
